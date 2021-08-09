{ config, lib, tf, ... }:

/*
This module:
* Provides options for setting the domain/tld/... used by default in my service configs.
*/

with lib;

{
  options.kw.dns = {
    email = mkOption {
      type = types.nullOr types.str;
      default = "";
    };
    tld = mkOption {
      type = types.nullOr types.str;
      default = "";
    };
    domain = mkOption {
      type = types.nullOr types.str;
      default = "";
    };
    ygg_prefix = mkOption {
      type = types.nullOr types.str;
      default = "";
    };
    isPublic = mkEnableOption "Provide DNS for the public primary IP addresses of the host";
    ipv4 = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    ipv6 = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = {
    # Set these.
    kw.dns.email = mkDefault "kat@kittywit.ch";
    kw.dns.tld = mkDefault "kittywit.ch.";
    kw.dns.ygg_prefix = mkDefault "net";

    # This should be set in host config if it needs to be set for a host. Otherwise, they're retrieved from terraform.
    kw.dns.ipv4 = mkDefault (mkIf (tf.resources ? config.networking.hostName) (mkOptionDefault (config.deploy.tf.resources."${config.networking.hostName}".refAttr "ipv4_address")));
    kw.dns.ipv6 = mkDefault (mkIf (tf.resources ? config.networking.hostName) (mkOptionDefault (config.deploy.tf.resources."${config.networking.hostName}".refAttr "ipv6_address")));

    # These are derived.
    kw.dns.domain = builtins.substring 0 ((builtins.stringLength config.kw.dns.tld) - 1) config.kw.dns.tld;

    deploy.tf.dns.records = lib.mkIf (config.kw.dns.isPublic) {
      "node_${config.networking.hostName}_v4" = {
        tld = config.kw.dns.tld;
        domain = config.networking.hostName;
        a.address = config.kw.dns.ipv4;
      };
      "node_${config.networking.hostName}_v6" = {
        tld = config.kw.dns.tld;
        domain = config.networking.hostName;
        aaaa.address = config.kw.dns.ipv6;
      };
    };
  };
}
