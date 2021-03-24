{ config, pkgs, witch, ... }:

{
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
}
