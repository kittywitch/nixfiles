{ config, kw, ... }:

{
  kw.fw.private.tcp.ports = [ 19999 ];

  services.netdata = { enable = true; };

  services.nginx.virtualHosts = kw.virtualHostGen {
    block = {
      locations."/netdata" = {
        proxyPass = "http://[::1]:19999/";
      };
    };
  };
}
