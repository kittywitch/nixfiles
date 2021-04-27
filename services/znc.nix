{ config, lib, pkgs, witch, ... }:

with lib;

{
  katnet.public.tcp.ports = singleton 5001;

  services.znc = {
    enable = true;
    mutable = false;
    useLegacyConfig = false;
    openFirewall = false;
    config = {
      Listener.l = {
        Port = 5000;
        SSL = false;
        AllowWeb = true;
      };
      Listener.j = {
        Port = 5001;
        SSL = true;
        AllowWeb = false;
      };
      modules = [ "webadmin" "adminlog" ];
      User = witch.secrets.hosts.athame.znc;
    };
  };

  services.nginx.virtualHosts."znc.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:5000"; };
  };

  deploy.tf.dns.records.kittywitch_znc = {
    tld = "kittywit.ch.";
    domain = "znc";
    cname.target = "athame.kittywit.ch.";
  };
}
