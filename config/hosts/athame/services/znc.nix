{ config, pkgs, ... }:

let secrets = (import ../../../../secrets.nix);
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
      User.kat = {
        Admin = true;
        Nick = secrets.hosts.athame.znc.nick;
        AltNick = secrets.hosts.athame.znc.altNick;
        Network.freenode = {
          Server = "chat.freenode.net +6697 ${secrets.hosts.athame.znc.freenode.password}";
          Chan = secrets.hosts.athame.znc.freenode.channels;
          Nick = secrets.hosts.athame.znc.freenode.nick;
          AltNick = secrets.hosts.athame.znc.freenode.altNick;
          JoinDelay = 2;
          LoadModule = [ "simple_away" "nickserv" ];
        };
        Network.espernet = {
          Server = "anarchy.esper.net +6697 ${secrets.hosts.athame.znc.espernet.password}";
          Chan = secrets.hosts.athame.znc.espernet.channels;
          Nick = secrets.hosts.athame.znc.espernet.nick;
          AltNick = secrets.hosts.athame.znc.espernet.altNick;
          JoinDelay = 2;
          LoadModule = [ "simple_away" "nickserv" ];
        };
        Pass.password = {
          Method = secrets.hosts.athame.znc.password.method;
          Hash = secrets.hosts.athame.znc.password.hash;
          Salt = secrets.hosts.athame.znc.password.salt;
        };
      };
    };
  };
}
