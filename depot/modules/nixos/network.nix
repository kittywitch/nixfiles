{ config, lib, tf, ... }:

with lib;

let
  cfg = config.network;
in {
  options.network = {
    addresses = mkOption {
      type = with types; attrsOf (submodule ({ name, options, config, ... }: {
        options = {
          enable = mkEnableOption "Is the system a part of the ${name} network?" // {
            default = config.ipv4.enable || config.ipv6.enable;
          };
          ipv4 = {
            enable = mkOption {
              type = types.bool;
              default = options.ipv4.address.isDefined;
            };
            address = mkOption {
              type = types.str;
            };
          };
          ipv6 = {
            enable = mkOption {
              type = types.bool;
              default = options.ipv6.address.isDefined;
            };
            address = mkOption {
              type = types.str;
            };
          };
          prefix = mkOption {
            type = types.nullOr types.str;
          };
          subdomain = mkOption {
            type = types.nullOr types.str;
          };
          domain = mkOption {
            type = types.nullOr types.str;
            default = "${config.subdomain}.${cfg.dns.domain}";
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
      default = "192.168.1.254";
    };
    tf = {
      enable = mkEnableOption "Was the system provisioned by terraform?";
      ipv4_attr = mkOption {
        type = types.str;
        default = "ipv4_address";
      };
      ipv6_attr = mkOption {
        type = types.str;
        default = "ipv6_address";
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
    };
  };

  config = let
    networks = cfg.addresses;
    networksWithDomains = filterAttrs (_: v: v.subdomain != null) networks;
  in {
    lib.kw.virtualHostGen = args: virtualHostGen ({ inherit config; } // args);

    network = {
      dns = {
        email = "kat@kittywit.ch";
        tld = "kittywit.ch.";
        domain = builtins.substring 0 ((builtins.stringLength cfg.dns.tld) - 1) cfg.dns.tld;
      };
      addresses = {
        private =  {
          prefix = "int";
          subdomain = "${config.networking.hostName}.${cfg.addresses.private.prefix}";
        };
        public = mkMerge [
          (mkIf cfg.tf.enable {
            ipv4.address = mkIf (cfg.tf.ipv4_attr != null) (tf.resources."${config.networking.hostName}".refAttr config.network.tf.ipv4_attr);
            ipv6.address = mkIf (cfg.tf.ipv6_attr != null) (tf.resources."${config.networking.hostName}".refAttr config.network.tf.ipv6_attr);
          })
          ({
            subdomain = "${config.networking.hostName}";
          })
        ];
        yggdrasil = mkIf cfg.yggdrasil.enable {
          ipv6.address = cfg.yggdrasil.address;
          prefix = "ygg";
          subdomain = "${config.networking.hostName}.${cfg.addresses.yggdrasil.prefix}";
        };
      };
    };

    networking = mkIf cfg.addresses.private.enable {
      inherit (config.network.dns) domain;
      defaultGateway = cfg.privateGateway;
    };

    deploy.tf.dns.records = let
      recordsV4 = mapAttrs' (n: v:
      nameValuePair "node_${n}_${config.networking.hostName}_v4" {
        enable = v.ipv4.enable;
        tld = cfg.dns.tld;
        domain = v.subdomain;
        a.address = v.ipv4.address;
      }) networksWithDomains;
      recordsV6 = mapAttrs' (n: v:
      nameValuePair "node_${n}_${config.networking.hostName}_v6" {
        enable = v.ipv6.enable;
        tld = cfg.dns.tld;
        domain = v.subdomain;
        aaaa.address = v.ipv6.address;
      }) networksWithDomains;
    in recordsV4 // recordsV6;

    security.acme.certs = mkIf config.services.nginx.enable (mapAttrs' (n: v:
    nameValuePair "cert_${n}_${config.networking.hostName}" {
      inherit (v) domain;
      dnsProvider = "rfc2136";
      credentialsFile = config.secrets.files.dns_creds.path;
      group = "nginx";
    }) networksWithDomains);

    services.nginx.virtualHosts = mkIf config.services.nginx.enable (mapAttrs' (n: v:
    nameValuePair v.domain {
      useACMEHost = "cert_${n}_${config.networking.hostName}";
      forceSSL = true;
    }) networksWithDomains);

    _module.args = { inherit (config.lib) kw; };
  };
}
