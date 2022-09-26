{ config, tf, meta, kw, pkgs, lib, inputs, ... }:  let
  oci-root = meta.deploy.targets.oci-root.tf;
  cfg = config.kw.oci;
in
{
  options.kw.oci = {
    base = lib.mkOption {
      description = ''
        Canonical Ubuntu provides an EXT4 root filesystem.
        Oracle Linux provides an XFS root filesystem.
      '';
      type = lib.types.enum [
        "Canonical Ubuntu"
        "Oracle Linux"
      ];
      default = "Canonical Ubuntu";
    };
    specs = {
      shape = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      cores = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
      ram = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
      space = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
    };
    network = {
      privateV4 = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
      publicV6 = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
    };
    ad = lib.mkOption {
      description = ''
        Availability Domain.
        Important because, for example: EPYC instances can only be provisioned on AD2 in London.
      '';
      type = lib.types.nullOr lib.types.int;
      default = null;
    };
  };
  imports = with import (inputs.tf-nix + "/modules"); [
    nixos.oracle
  ];
  config =
    let
      interface = lib.attrByPath [ cfg.specs.shape ] (throw "Unsupported shape") {
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
              addresses = lib.mkIf (config.networks.internet.ipv6_defined) [{
                address = config.networks.internet.ipv6;
                prefixLength = 64;
              }];
              routes = [{
                address = "::";
                prefixLength = 0;
              }];
            };
          };
        };

      networks = {
        internet = lib.mkMerge [
        (lib.mkIf tf.state.enable {
          interfaces = lib.singleton interface;
          ipv4 = lib.mkOrder 1000 (tf.resources.${config.networking.hostName}.getAttr "public_ip");
          ipv6 = let
            prefix = lib.head (lib.splitString "/" (oci-root.resources.oci_kw_subnet.importAttr "ipv6cidr_block"));
          in assert lib.hasSuffix "::" prefix; prefix + toString config.kw.oci.network.publicV6;
          ip = hostname: class: if hostname != config.networking.hostName then
              if class == 6 then let
                  prefix = lib.head (lib.splitString "/" (oci-root.resources.oci_kw_subnet.importAttr "ipv6cidr_block"));
                in assert lib.hasSuffix "::" prefix; prefix + toString config.kw.oci.network.publicV6
              else if class == 4 then
                tf.resources.${config.networking.hostName}.importAttr "public_ip"
                else throw "${config.networking.hostName}: IP for ${hostname} of ${toString class} is invalid."
            else
              if class == 6 then let
                  prefix = lib.head (lib.splitString "/" (oci-root.resources.oci_kw_subnet.importAttr "ipv6cidr_block"));
                in assert lib.hasSuffix "::" prefix; prefix + toString config.kw.oci.network.publicV6
              else if class == 4 then
                tf.resources.${config.networking.hostName}.getAttr "public_ip"
                else throw "${config.networking.hostName}: IP for ${hostname} of ${toString class} is invalid.";
          })
          (lib.mkIf (!tf.state.enable) {
            interfaces = lib.singleton "whee";
          })
        ];
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
              port = lib.head config.services.openssh.ports;
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
          resources = lib.mkMerge [{
            cloudinit = {
              provider = "cloudinit";
              type = "config";
              dataSource = true;
              inputs = {
                part = lib.singleton {
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
                  ssh_authorized_keys = lib.concatStringsSep "\n" config.users.users.root.openssh.authorizedKeys.keys;
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
                "create_vnic_details[0].defined_tags"
                "defined_tags"
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
                        if lib.isAttrs port then {
                          min = port.from;
                          max = port.to;
                        } else {
                          min = port;
                          max = port;
                        };
                    };
                  };
                };
                sourceProtos = lib.cartesianProductOfSets {
                  source = [ ipv4 ipv6 ];
                  protocol = [ protoValues.TCP protoValues.UDP ];
                };
                mapPortswheeee = port: map ({ source, protocol }: mapPort source protocol port) sourceProtos;
                rules = mapPortswheeee { from = 1; to = 65535; };
                /*mapAll = protocol: port: [ (mapPort ipv4 protocol port) (mapPort ipv6 protocol port) ];
                mapAllForInterface =
                  let
                    protos = [ "TCP" "UDP" ];
                    types = [ "Ports" "PortRanges" ];
                  in
                  interface: concatMap (type: concatMap (proto: (concatMap (port: (mapAll protoValues.${proto}) port) interface."allowed${proto}${type}")) protos) types;
                rules = concatMap mapAllForInterface ([ firewall ] ++ map (interface: firewall.interfaces.${interface}) config.network.firewall.public.interfaces);*/
                # TODO: use `count` and index into a fancy json or something?
              in
              lib.listToAttrs (lib.imap0 (i: rule: lib.nameValuePair "firewall${toString i}" rule) rules)
            )];
        };
    };
}
