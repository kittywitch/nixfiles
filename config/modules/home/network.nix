{ config, nixos, lib, ... }:

with lib;

{
  options.network = {
    enable = mkEnableOption "Use kat's network module?";
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
          out = {
            identifierList = mkOption {
              type = types.listOf types.str;
              default = if config.enable then singleton config.domain ++ config.out.addressList else [ ];
            };
            addressList = mkOption {
              type = types.listOf types.str;
              default = if config.enable then concatMap (i: optional i.enable i.address) [ config.ipv4 config.ipv6 ] else [ ];
            };
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
      enable = mkEnableOption "Do you want DNS to be semi-managed through this module?";
      isRoot = mkEnableOption "Is this system supposed to be the @ for the domain?";
      email = mkOption {
        type = types.nullOr types.str;
      };
      zone = mkOption {
        type = types.nullOr types.str;
      };
      domain = mkOption {
        type = types.nullOr types.str;
      };
      dynamic = mkEnableOption "Enable Glauca Dynamic DNS Updater";
    };
  };

  config = {
    network.addresses = nixos.network.addresses or {};
    network.privateGateway = nixos.network.privateGateway or "";
    network.tf = nixos.network.tf or {};
    network.dns = nixos.network.dns or {};
  };
}
