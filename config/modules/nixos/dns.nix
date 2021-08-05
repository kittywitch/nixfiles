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
    ipv4 = mkOption {
      type = types.str;
    };
    ipv6 = mkOption {
      type = types.str;
    };
  };

  config = {
    # Set these.
    kw.dns.email = "kat@kittywit.ch";
    kw.dns.tld = "kittywit.ch.";
    kw.dns.ygg_prefix = "net";

    # This should be set in host config if it needs to be set for a host. Otherwise, they're retrieved from terraform.
    kw.dns.ipv4 = mkIf (tf.resources ? config.networking.hostName) (mkOptionDefault (config.deploy.tf.resources."${config.networking.hostName}".refAttr "ipv4_address"));
    kw.dns.ipv6 = mkIf (tf.resources ? config.networking.hostName) (mkOptionDefault (config.deploy.tf.resources."${config.networking.hostName}".refAttr "ipv6_address"));

    # This is derived.
    kw.dns.domain = builtins.substring 0 ((builtins.stringLength config.kw.dns.tld) - 1) config.kw.dns.tld;
  };
}
