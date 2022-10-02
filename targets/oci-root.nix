{ config, lib, ... }: with lib; {
  deploy.targets.oci-root = {
    tf =
      let
        meta = config;
      in
      { config, ... }:
      let
        inherit (config.lib.tf) terraformExpr;
        res = config.resources;
        var = config.variables;
        out = config.outputs;
      in
      {
        variables =
          let
            apivar = {
              type = "string";
              sensitive = true;
            };
          in
          mkMerge [
            (genAttrs (map (value: "oci_root_${value}") [ "region" "tenancy" "user" "fingerprint" ]) (attr: {
              value.shellCommand = "bitw get services/host/oracleapi -f ${head (reverseList (splitString "_" attr))}";
              type = "string";
            }))
            { "oci_root_privkey" = {
              value.shellCommand = "bitw get services/host/oracleapi";
              type = "string";
              sensitive = true;
            }; }
          ];

        providers.oci-root = {
          type = "oci";
          inputs = with config.variables; {
            tenancy_ocid = oci_root_tenancy.ref;
            user_ocid = oci_root_user.ref;
            private_key = oci_root_privkey.ref;
            fingerprint = oci_root_fingerprint.ref;
            region = oci_root_region.ref;
          };
        };

        resources = {
          oci_nixfiles_compartment = {
            provider = "oci.oci-root";
            type = "identity_compartment";
            inputs = {
              name = "nixfiles";
              description = "nixfiles";
              compartment_id = var.oci_root_tenancy.ref;
              enable_delete = true;
            };
          };
          oci_nixfiles_user = {
            provider = "oci.oci-root";
            type = "identity_user";
            inputs = {
              name = "nixfiles";
              description = "nixfiles";
              compartment_id = var.oci_root_tenancy.ref;
            };
          };
          oci_nixfiles_group = {
            provider = "oci.oci-root";
            type = "identity_group";
            inputs = {
              name = "nixfiles";
              description = "nixfiles";
              compartment_id = var.oci_root_tenancy.ref;
            };
          };
          oci_nixfiles_usergroup = {
            provider = "oci.oci-root";
            type = "identity_user_group_membership";
            inputs = {
              group_id = res.oci_nixfiles_group.refAttr "id";
              user_id = res.oci_nixfiles_user.refAttr "id";
            };
          };
          oci_nixfiles_key = {
            provider = "tls";
            type = "private_key";
            inputs = {
              algorithm = "RSA";
              rsa_bits = 2048;
            };
          };
          oci_nixfiles_key_file = {
            provider = "local";
            type = "file";
            inputs = {
              sensitive_content = res.oci_nixfiles_key.refAttr "private_key_pem";
              filename = toString (config.terraform.dataDir + "/oci_nixfiles_key");
              file_permission = "0600";
            };
          };
          oci_nixfiles_apikey = {
            provider = "oci.oci-root";
            type = "identity_api_key";
            inputs = {
              key_value = res.oci_nixfiles_key.refAttr "public_key_pem";
              user_id = res.oci_nixfiles_user.refAttr "id";
            };
          };
          oci_nixfiles_policy = {
            provider = "oci.oci-root";
            type = "identity_policy";
            inputs = {
              name = "nixfiles-admin";
              description = "nixfiles admin";
              compartment_id = var.oci_root_tenancy.ref;
              statements = [
                "Allow group ${res.oci_nixfiles_group.refAttr "name"} to manage all-resources in compartment id ${res.oci_nixfiles_compartment.refAttr "id"}"
                "Allow group ${res.oci_nixfiles_group.refAttr "name"} to read virtual-network-family in compartment id ${var.oci_root_tenancy.ref}"
                ''
                  Allow group ${res.oci_nixfiles_group.refAttr "name"} to manage vcns in compartment id ${var.oci_root_tenancy.ref} where ALL {
                  ANY { request.operation = 'CreateNetworkSecurityGroup', request.operation = 'DeleteNetworkSecurityGroup' }
                  }
                ''
              ];
            };
          };
          oci_vcn = {
            provider = "oci.oci-root";
            type = "core_vcn";
            inputs = {
              display_name = "net";
              compartment_id = var.oci_root_tenancy.ref;
              cidr_blocks = [
                "10.69.0.0/16"
              ];
              is_ipv6enabled = true;
            };
          };
          oci_internet = {
            provider = "oci.oci-root";
            type = "core_internet_gateway";
            inputs = {
              display_name = "net internet";
              compartment_id = var.oci_root_tenancy.ref;
              vcn_id = res.oci_vcn.refAttr "id";
            };
          };
          oci_routes = {
            provider = "oci.oci-root";
            type = "core_route_table";
            inputs = {
              display_name = "net routes";
              route_rules = [
                {
                  description = "internet v4";
                  destination_type = "CIDR_BLOCK";
                  destination = "0.0.0.0/0";
                  network_entity_id = res.oci_internet.refAttr "id";
                }
                {
                  description = "internet v6";
                  destination_type = "CIDR_BLOCK";
                  destination = "::/0";
                  network_entity_id = res.oci_internet.refAttr "id";
                }
              ];
              compartment_id = var.oci_root_tenancy.ref;
              vcn_id = res.oci_vcn.refAttr "id";
            };
          };
          oci_nixfiles_subnet = {
            provider = "oci.oci-root";
            type = "core_subnet";
            inputs = {
              display_name = "nixfiles";
              cidr_block = terraformExpr "cidrsubnet(${res.oci_vcn.namedRef}.cidr_blocks[0], 8, 8)"; # /24
              ipv6cidr_block = terraformExpr "cidrsubnet(${res.oci_vcn.namedRef}.ipv6cidr_blocks[0], 8, 0)"; # from a /56 block to /64
              compartment_id = res.oci_nixfiles_compartment.refAttr "id";
              vcn_id = res.oci_vcn.refAttr "id";
              route_table_id = res.oci_routes.refAttr "id";
            };
          };
        };
        outputs = {
          oci_region = {
            value = var.oci_root_region.ref;
            sensitive = true;
          };
          oci_tenancy = {
            value = var.oci_root_tenancy.ref;
            sensitive = true;
          };
        };
      };
  };
}
