{ config, superConfig, lib, ... }:

with lib;

{
  options.network = {
    addresses = mkOption {
      type = with types; attrsOf (submodule ({ name, ... }: {
        options = {
          enable = mkEnableOption "Is the system a part of the ${name} network?";
          ipv4 = {
            enable = mkOption {
              type = types.bool;
            };
            address = mkOption {
              type = types.str;
            };
          };
          ipv6 = {
            enable = mkOption {
              type = types.bool;
            };
            address = mkOption {
              type = types.str;
            };
          };
          prefix = mkOption {
            type = types.nullOr types.str;
          };
          domain = mkOption {
            type = types.nullOr types.str;
          };
        };
      }));
    };
    privateGateway = mkOption {
      type = types.str;
    };
    tf = {
      enable = mkEnableOption "Was the system provisioned by terraform?";
      ipv4_attr = mkOption {
        type = types.str;
      };
      ipv6_attr = mkOption {
        type = types.str;
      };
    };
    dns = {
      email = mkOption {
        type = types.nullOr types.str;
      };
      tld = mkOption {
        type = types.nullOr types.str;
      };
      domain = mkOption {
        type = types.nullOr types.str;
      };
      dynamic = mkEnableOption "Enable Glauca Dynamic DNS Updater";
    };
  };

  config = {
    network.addresses = superConfig.network.addresses;
    network.privateGateway = superConfig.network.privateGateway;
    network.tf = superConfig.network.tf;
    network.dns = superConfig.network.dns;
  };
}
