{ config, pkgs, ... }:

let secrets = import ../secrets.nix; in {
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
                Nick = secrets.znc.nick;
                AltNick = secrets.znc.altNick;
                Network.freenode = {
                    Server = "chat.freenode.net +6697 ${secrets.znc.freenode.password}";
                    Chan = secrets.znc.freenode.channels;
                    Nick = secrets.znc.freenode.nick;
                    AltNick = secrets.znc.freenode.altNick;
                    JoinDelay = 2;
                    LoadModule = [
                        "simple_away"
                        "nickserv"
                    ];
                };
                Network.espernet = {
                    Server = "anarchy.esper.net +6697 ${secrets.znc.espernet.password}";
                    Chan = secrets.znc.espernet.channels;
                    Nick = secrets.znc.espernet.nick;
                    AltNick = secrets.znc.espernet.altNick;
                    JoinDelay = 2;
                    LoadModule = [
                        "simple_away"
                        "nickserv"
                    ];
                };
                Pass.password = {
                    Method = secrets.znc.password.method;
                    Hash = secrets.znc.password.hash;
                    Salt = secrets.znc.password.salt;
                };
            };
        };
    };  
}