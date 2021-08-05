{ config, lib, ... }:

/*
This module:
  * Provides AAAA records on a per-host basis for each yggdrasil enabled host.
  * Provides certificates for those hosts if they run NGINX.
*/

with lib;

{
  config = {
    deploy.tf.dns.records."ygg_${config.networking.hostName}" =
      mkIf (config.network.yggdrasil.enable) {
        tld = config.kw.dns.tld;
        domain = "${config.networking.hostName}.${config.kw.dns.ygg_prefix}";
        aaaa.address = config.network.yggdrasil.address;
      };
    security.acme.certs."${config.networking.hostName}.${config.kw.dns.ygg_prefix}.${config.kw.dns.domain}" =
      mkIf (config.services.nginx.enable && config.network.yggdrasil.enable) {
        domain = "${config.networking.hostName}.${config.kw.dns.ygg_prefix}.${config.kw.dns.domain}";
        dnsProvider = "rfc2136";
        credentialsFile = config.secrets.files.dns_creds.path;
        group = "nginx";
      };
  };
}
