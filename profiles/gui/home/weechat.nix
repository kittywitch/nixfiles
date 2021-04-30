{ config, pkgs, lib, superConfig, ... }:

{
  home.file = {
    ".local/share/weechat/sec.conf" = lib.mkIf config.deploy.profile.private {
      source = ../../../private/files/weechat/sec.conf;
    };
  };
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
            autoconnect = true;
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
          autoconnect = true;
        };
      };
    };
  };
}
