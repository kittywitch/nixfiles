{ config, pkgs, lib, superConfig, ... }:

{
  programs.weechat = {
    enable = true;
    config = {
      irc = {
        server = {
          freenode = {
            address = "athame.kittywit.ch/5001";
            password = "kat/freenode:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = false;
          };
          espernet = {
            address = "athame.kittywit.ch/5001";
            password = "kat/espernet:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
        };
      };
      matrix = {
        server.kat = {
          address = "kittywit.ch";
          device_name = "${superConfig.networking.hostName}/weechat";
          username = "kat";
          password = "\${sec.data.matrix}";
        };
      };
    };
  };
}
