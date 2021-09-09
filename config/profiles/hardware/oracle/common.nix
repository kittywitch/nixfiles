{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; let
  oci-root = meta.deploy.targets.oci-root.tf;
  cfg = config.kw.oci;
in
{
  options.kw.oci = {
    base = mkOption {
      description = ''
        Canonical Ubuntu provides an EXT4 root filesystem.
        Oracle Linux provides an XFS root filesystem.
      '';
      type = with types; enum [
        "Canonical Ubuntu"
        "Oracle Linux"
      ];
      default = "Canonical Ubuntu";
    };
    specs = {
      shape = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      cores = mkOption {
        type = with types; nullOr int;
        default = null;
      };
      ram = mkOption {
        type = with types; nullOr int;
        default = null;
      };
      space = mkOption {
        type = with types; nullOr int;
        default = null;
      };
    };
    network = {
      privateV4 = mkOption {
        type = with types; nullOr int;
        default = null;
      };
      publicV6 = mkOption {
        type = with types; nullOr int;
        default = null;
      };
    };
    ad = mkOption {
      description = ''
        Availability Domain.
        Important because, for example: EPYC instances can only be provisioned on AD2 in London.
      '';
      type = with types; nullOr int;
      default = null;
    };
  };
  imports = with import (sources.tf-nix + "/modules"); [
    nixos.oracle
  ];
  config =
    let
      interface = attrByPath [ cfg.specs.shape ] (throw "Unsupported shape") {
        "VM.Standard.A1.Flex" = "enp0s3";
        "VM.Standard.E2.1.Micro" = "ens3";
      };
    in
    {
      networking.interfaces =
        {
          ${interface} = {
            useDHCP = true;
            ipv6 = {
              addresses = mkIf (config.network.addresses.public.nixos.ipv6.enable) [{
                address = config.network.addresses.public.nixos.ipv6.address;
                prefixLength = 64;
              }];
              routes = [{
                address = "::";
                prefixLength = 0;
              }];
            };
          };
        };

      network = {
        addresses = {
          public =
            let
              addr_ipv6_nix =
                let
                  prefix = head (splitString "/" (oci-root.resources.oci_kw_subnet.importAttr "ipv6cidr_block"));
                in
                assert hasSuffix "::" prefix; prefix + toString config.kw.oci.network.publicV6;
            in
            {
              enable = true;
              nixos.ipv6.address = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference}) addr_ipv6_nix;
              tf.ipv6.address = tf.resources."${config.networking.hostName}_ipv6".refAttr "ip_address";
            };
        };
        firewall.public.interfaces = singleton interface;
        tf = {
          enable = true;
          ipv4_attr = "public_ip";
        };
      };

      deploy.tf =
        let
          compartment_id = oci-root.resources.oci_kw_compartment.importAttr "id";
          inherit (tf.lib.tf) terraformExpr;
        in
        {
          deploy.systems."${config.networking.hostName}" = {
            lustrate = {
              enable = true;
              connection = tf.resources."${config.networking.hostName}".connection.set;
            };
            connection = {
              port = head config.services.openssh.ports;
            };
          };
          providers.oci = {
            inputs = {
              tenancy_ocid = oci-root.outputs.oci_tenancy.import;
              user_ocid = oci-root.resources.oci_kw_user.importAttr "id";
              fingerprint = oci-root.resources.oci_kw_apikey.importAttr "fingerprint";
              region = oci-root.outputs.oci_region.import;
              private_key_path = oci-root.resources.oci_kw_key_file.importAttr "filename";
            };
          };
          resources = mkMerge [{
            cloudinit = {
              provider = "cloudinit";
              type = "config";
              dataSource = true;
              inputs = {
                part = singleton {
                  content_type = "text/cloud-config";
                  content = "#cloud-config\n" + builtins.toJSON {
                    disable_root = false;
                  };
                };
              };
            };
            availability_domain = {
              provider = "oci";
              type = "identity_availability_domain";
              dataSource = true;
              inputs = {
                inherit compartment_id;
                ad_number = cfg.ad;
              };
            };
            generic_image = {
              provider = "oci";
              type = "core_images";
              dataSource = true;
              inputs = {
                inherit compartment_id;
                inherit (tf.resources."${config.networking.hostName}".inputs) shape;
                operating_system = cfg.base;
                sort_by = "TIMECREATED";
                sort_order = "DESC";
              };
            };
            "${config.networking.hostName}_vnic" = {
              provider = "oci";
              type = "core_vnic_attachments";
              dataSource = true;
              inputs = {
                inherit compartment_id;
                instance_id = tf.resources."${config.networking.hostName}".refAttr "id";
              };
            };
            "${config.networking.hostName}_ipv6" = {
              provider = "oci";
              type = "core_ipv6";
              inputs = {
                vnic_id = tf.resources."${config.networking.hostName}_vnic".refAttr "vnic_attachments[0].vnic_id";
                display_name = config.networking.hostName;
                ip_address = terraformExpr ''cidrhost("${oci-root.resources.oci_kw_subnet.importAttr "ipv6cidr_block"}", ${toString cfg.network.publicV6})'';
              };
            };
            "${config.networking.hostName}" = {
              provider = "oci";
              type = "core_instance";
              inputs = {
                inherit compartment_id;
                extended_metadata = { };
                metadata = {
                  ssh_authorized_keys = concatStringsSep "\n" config.users.users.root.openssh.authorizedKeys.keys;
                  user_data = tf.resources.cloudinit.refAttr "rendered";
                };
                shape = cfg.specs.shape;
                shape_config = {
                  ocpus = cfg.specs.cores;
                  memory_in_gbs = cfg.specs.ram;
                };
                source_details = {
                  source_type = "image";
                  source_id = tf.resources.generic_image.refAttr "images[0].id";
                  boot_volume_size_in_gbs = cfg.specs.space; # min 50GB, up to 200GB free
                };
                create_vnic_details = [
                  {
                    assign_public_ip = true;
                    subnet_id = oci-root.resources.oci_kw_subnet.importAttr "id";
                    private_ip = terraformExpr ''cidrhost("${oci-root.resources.oci_kw_subnet.importAttr "cidr_block"}", ${toString cfg.network.privateV4})'';
                    nsg_ids = [
                      (tf.resources.firewall_group.refAttr "id")
                    ];
                  }
                ];
                availability_domain = tf.resources.availability_domain.refAttr "name";
              };
              lifecycle.ignoreChanges = [
                "source_details[0].source_id"
                "metadata"
              ];
              connection = {
                type = "ssh";
                user = "root";
                host = tf.lib.tf.terraformSelf "public_ip";
                timeout = "5m";
              };
            };
            firewall_group = {
              provider = "oci";
              type = "core_network_security_group";
              inputs = {
                display_name = "${config.networking.hostName} firewall group";
                inherit compartment_id;
                vcn_id = oci-root.resources.oci_vcn.importAttr "id";
              };
            };
          }
            (
              let
                protoValues = {
                  TCP = 6;
                  UDP = 17;
                };
                inherit (config.networking) firewall;
                ipv4 = "0.0.0.0/0";
                ipv6 = "::/0";
                mapPort = source: protocol: port: {
                  provider = "oci";
                  type = "core_network_security_group_security_rule";
                  inputs = {
                    network_security_group_id = tf.resources.firewall_group.refAttr "id";
                    inherit protocol source;
                    direction = "INGRESS";
                    ${if protocol == protoValues.TCP then "tcp_options" else "udp_options"} = {
                      destination_port_range =
                        if isAttrs port then {
                          min = port.from;
                          max = port.to;
                        } else {
                          min = port;
                          max = port;
                        };
                    };
                  };
                };
                mapAll = protocol: port: [ (mapPort ipv4 protocol port) (mapPort ipv6 protocol port) ];
                mapAllForInterface =
                  let
                    protos = [ "TCP" "UDP" ];
                    types = [ "Ports" "PortRanges" ];
                  in
                  interface: concatMap (type: concatMap (proto: (concatMap (port: (mapAll protoValues.${proto}) port) interface."allowed${proto}${type}")) protos) types;
                rules = concatMap mapAllForInterface ([ firewall ] ++ map (interface: firewall.interfaces.${interface}) config.network.firewall.public.interfaces);
                # TODO: use `count` and index into a fancy json or something?
              in
              listToAttrs (imap0 (i: rule: nameValuePair "firewall${toString i}" rule) rules)
            )];
        };
    };
}
