{ config, lib, tf, pkgs, ... }:

with lib;

let
  cfg = config.network;
in
{
  options.network = {
    enable = mkEnableOption "Use kat's network module?";
    addresses = mkOption {
      type = with types; attrsOf (submodule ({ name, options, config, ... }: {
        options = {
          enable = mkEnableOption "Is it a member of the ${name} network?";
          nixos = {
            ipv4 = {
              enable = mkOption {
                type = types.bool;
                default = options.nixos.ipv4.address.isDefined;
              };
              selfaddress = mkOption {
                type = types.str;
              };
              address = mkOption {
                type = types.str;
              };
            };
            ipv6 = {
              enable = mkOption {
                type = types.bool;
                default = options.nixos.ipv6.address.isDefined;
              };
              selfaddress = mkOption {
                type = types.str;
              };
              address = mkOption {
                type = types.str;
              };
            };
          };
          tf = {
            ipv4 = {
              enable = mkOption {
                type = types.bool;
                default = options.tf.ipv4.address.isDefined;
              };
              address = mkOption {
                type = types.str;
              };
            };
            ipv6 = {
              enable = mkOption {
                type = types.bool;
                default = options.tf.ipv6.address.isDefined;
              };
              address = mkOption {
                type = types.str;
              };
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
          target = mkOption {
            type = types.nullOr types.str;
            default = "${config.domain}.";
          };
          out = {
            identifierList = mkOption {
              type = types.listOf types.str;
              default = optionals config.enable (singleton config.domain ++ config.out.addressList);
            };
            addressList = mkOption {
              type = types.listOf types.str;
              default = optionals config.enable (concatMap (i: optional i.enable i.address) [ config.nixos.ipv4 config.nixos.ipv6 ]);
            };
          };
        };
      }));
    };
    extraCerts = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
    privateGateway = mkOption {
      type = types.str;
      default = "192.168.1.254";
    };
    tf = {
      enable = mkEnableOption "Was the system provisioned by terraform?";
      ipv4_attr = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      ipv6_attr = mkOption {
        type = types.nullOr types.str;
        default = null;
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
    };
  };

  config =
    let
      networks = cfg.addresses;
      networksWithDomains = filterAttrs (_: v: v.enable) networks;
    in
    mkIf cfg.enable {
      lib.kw.virtualHostGen = args: virtualHostGen ({ inherit config; } // args);

      network = {
        dns = {
          domain = builtins.substring 0 ((builtins.stringLength cfg.dns.zone) - 1) cfg.dns.zone;
        };
        addresses = lib.mkMerge [
          (mkIf (!cfg.tf.enable) (genAttrs [ "private" "public" "yggdrasil" "wireguard" ] (network: {
            tf = {
              ipv4.address = mkIf (cfg.addresses.${network}.nixos.ipv4.enable) cfg.addresses.${network}.nixos.ipv4.address;
              ipv6.address = mkIf (cfg.addresses.${network}.nixos.ipv6.enable) cfg.addresses.${network}.nixos.ipv6.address;
            };
          })))
          (mkIf cfg.tf.enable (genAttrs ["yggdrasil" "wireguard" ] (network: {
            tf = {
              ipv4.address = mkIf (cfg.addresses.${network}.nixos.ipv4.enable) cfg.addresses.${network}.nixos.ipv4.address;
              ipv6.address = mkIf (cfg.addresses.${network}.nixos.ipv6.enable) cfg.addresses.${network}.nixos.ipv6.address;
            };
          })))
          (mkIf cfg.tf.enable {
            public = {
              tf = {
                ipv4.address = mkIf (cfg.tf.ipv4_attr != null) (tf.resources.${config.networking.hostName}.refAttr cfg.tf.ipv4_attr);
                ipv6.address = mkIf (cfg.tf.ipv6_attr != null) (tf.resources.${config.networking.hostName}.refAttr cfg.tf.ipv6_attr);
              };
              nixos = {
                ipv4.selfaddress = mkIf (tf.state.enable && cfg.tf.ipv4_attr != null) (tf.resources.${config.networking.hostName}.getAttr cfg.tf.ipv4_attr);
                ipv6.selfaddress = mkIf (tf.state.enable && cfg.tf.ipv6_attr != null) (tf.resources.${config.networking.hostName}.getAttr cfg.tf.ipv6_attr);
                ipv4.address = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference} && cfg.tf.ipv4_attr != null) (tf.resources.${config.networking.hostName}.importAttr cfg.tf.ipv4_attr);
                ipv6.address = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference} && cfg.tf.ipv6_attr != null) (tf.resources.${config.networking.hostName}.importAttr cfg.tf.ipv6_attr);
              };
            };
          })
          ({
            private = {
              prefix = "int";
              subdomain = "${config.networking.hostName}.${cfg.addresses.private.prefix}";
            };
            yggdrasil = {
              enable = cfg.yggdrasil.enable;
              prefix = "ygg";
              subdomain = "${config.networking.hostName}.${cfg.addresses.yggdrasil.prefix}";
            };
            public = {
              subdomain = config.networking.hostName;
            };
          })
          (mkIf cfg.yggdrasil.enable {
            yggdrasil.nixos.ipv6.address = cfg.yggdrasil.address;
          })
        ];
      };

      services.yggdrasil.package = pkgs.yggdrasil-held;

      networking = mkIf cfg.addresses.private.enable {
        domain = mkDefault (if cfg.addresses.public.enable then cfg.addresses.domain
        else if cfg.addresses.private.enable then "${cfg.addresses.private.prefix}.${cfg.dns.domain}" else "");
        defaultGateway = cfg.privateGateway;
      };

      deploy.tf.dns.records =
        let
          recordsV4 = mapAttrs'
            (n: v:
              nameValuePair "node_${n}_${config.networking.hostName}_v4" {
                inherit (v.tf.ipv4) enable;
                inherit (cfg.dns) zone;
                domain = v.subdomain;
                a = { inherit (v.tf.ipv4) address; };
              })
            networksWithDomains;
          recordsV6 = mapAttrs'
            (n: v:
              nameValuePair "node_${n}_${config.networking.hostName}_v6" {
                inherit (v.tf.ipv6) enable;
                inherit (cfg.dns) zone;
                domain = v.subdomain;
                aaaa = { inherit (v.tf.ipv6) address; };
              })
            networksWithDomains;
        in
        mkMerge (map (record: mkIf cfg.dns.enable record) [
          recordsV4
          recordsV6
          (mkIf cfg.dns.isRoot {
            "node_root_${config.networking.hostName}_v4" = {
              inherit (cfg.addresses.public) enable;
              inherit (cfg.dns) zone;
              a = { inherit (cfg.addresses.public.tf.ipv4) address; };
            };
            "node_root_${config.networking.hostName}_v6" = {
              inherit (cfg.addresses.public) enable;
              inherit (cfg.dns) zone;
              aaaa = { inherit (cfg.addresses.public.tf.ipv6) address; };
            };
          })
        ]);

      security.acme.certs = mkMerge (map (cert: mkIf cfg.dns.enable cert) [
        (mkIf config.services.nginx.enable (mapAttrs'
          (n: v:
            nameValuePair "${n}_${config.networking.hostName}" {
              inherit (v) domain;
              dnsProvider = "rfc2136";
              credentialsFile = config.secrets.files.dns_creds.path;
              group = mkDefault "nginx";
            })
          networksWithDomains))
        (mapAttrs'
          (n: v:
            nameValuePair "${n}" {
              domain = v;
              dnsProvider = "rfc2136";
              credentialsFile = config.secrets.files.dns_creds.path;
              group = mkDefault "nginx";
            })
          cfg.extraCerts)
      ]);

      services.nginx.virtualHosts = mkMerge (map (host: mkIf cfg.dns.enable host) [
        (mkIf config.services.nginx.enable (mapAttrs'
          (n: v:
            nameValuePair v.domain {
              useACMEHost = "${n}_${config.networking.hostName}";
              forceSSL = true;
            })
          networksWithDomains))
        (mapAttrs'
          (n: v:
            nameValuePair v {
              useACMEHost = "${n}";
              forceSSL = true;
            })
          cfg.extraCerts)
      ]);

      _module.args = { inherit (config.lib) kw; };
    };
}
