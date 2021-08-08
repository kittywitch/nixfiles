{ config, superConfig, lib, tf, ... }:

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
    dynamic = mkEnableOption "Enable Glauca Dynamic DNS Updater";
  };
  config = {
    kw.dns = superConfig.kw.dns;
  };
}
