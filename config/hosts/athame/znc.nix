{ config, pkgs, ... }:

let secrets = (import ../../../secrets.nix);
in {
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
      modules = [ "webadmin" "adminlog" ];
      User = secrets.hosts.athame.znc;
    };
  };
}
