{ config, ... }:

{
  kw.fw.private.tcp.ports = [ 19999 ];

  services.netdata = { enable = true; };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "${config.networking.hostName}.${config.kw.dns.ygg_prefix}.${config.kw.dns.domain}" = {
        locations = { "/netdata" = { proxyPass = "http://[::1]:19999/"; }; };
      };
    };
  };
}
