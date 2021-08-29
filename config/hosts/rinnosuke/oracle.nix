{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; let
  oci-root = meta.deploy.targets.oci-root.tf;
in
{
  deploy.tf =
    let
      compartment_id = oci-root.resources.oci_kw_compartment.importAttr "id";
      inherit (tf.lib.tf) terraformExpr;
    in
    {
      deploy.systems.rinnosuke = {
        lustrate = {
          enable = true;
          connection = tf.resources.rinnosuke.connection.set;
        };
        connection = {
          port = 62954;
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
            ad_number = 2;
          };
        };
        generic_image = {
          provider = "oci";
          type = "core_images";
          dataSource = true;
          inputs = {
            inherit compartment_id;
            inherit (tf.resources.rinnosuke.inputs) shape;
            operating_system = "Canonical Ubuntu"; # "Oracle Linux"
            sort_by = "TIMECREATED";
            sort_order = "DESC";
          };
        };
        rinnosuke = {
          provider = "oci";
          type = "core_instance";
          inputs = {
            inherit compartment_id;
            extended_metadata = { };
            metadata = {
              ssh_authorized_keys = concatStringsSep "\n" config.users.users.root.openssh.authorizedKeys.keys;
              user_data = tf.resources.cloudinit.refAttr "rendered";
            };
            shape = "VM.Standard.E2.1.Micro";
            shape_config = {
              memory_in_gbs = 1;
              ocpus = 1;
            };
            source_details = {
              source_type = "image";
              source_id = tf.resources.generic_image.refAttr "images[0].id";
              boot_volume_size_in_gbs = 50; # min 50GB, up to 200GB free
            };
            create_vnic_details = [
              {
                assign_public_ip = true;
                subnet_id = oci-root.resources.oci_kw_subnet.importAttr "id";
                private_ip = terraformExpr ''cidrhost("${oci-root.resources.oci_kw_subnet.importAttr "cidr_block"}", 3)'';
                nsg_ids = [
                  (tf.resources.firewall_group.refAttr "id")
                ];
              }
            ];
            availability_domain = tf.resources.availability_domain.refAttr "name";
          };
          lifecycle.ignoreChanges = [
            "source_details[0].source_id"
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
}
