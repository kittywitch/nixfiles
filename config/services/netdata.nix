{ config, ... }:

{
  kw.fw.private.tcp.ports = [ 19999 ];

  services.netdata = { enable = true; };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "${config.networking.hostName}.net.kittywit.ch" = {
        useACMEHost = "${config.networking.hostName}.net.kittywit.ch";
        forceSSL = true;
        locations = { "/netdata" = { proxyPass = "http://[::1]:19999/"; }; };
      };
    };
  };
}
