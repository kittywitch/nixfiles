{ config, lib, nixos, pkgs, tf, ... }:

{
  kw.secrets.variables = {
    matrix-pass = {
      path = "social/matrix";
      field = "password";
    };
    znc-pass = {
      path = "social/irc/znc";
      field = "password";
    };
  };

  secrets.files.weechat-sec = {
    text = ''
      #
      # weechat -- sec.conf
      #
      # WARNING: It is NOT recommended to edit this file by hand,
      # especially if WeeChat is running.
      #
      # Use /set or similar command to change settings in WeeChat.
      #
      # For more info, see: https://weechat.org/doc/quickstart
      #

      [crypt]
      cipher = aes256
      hash_algo = sha512
      salt = off

      [data]
      __passphrase__ = off
      znc = "${tf.variables.znc-pass.ref}"
      matrix = "${tf.variables.matrix-pass.ref}"
    '';
    owner = "kat";
    group = "users";
  };

  home.file = {
    ".local/share/weechat/sec.conf".source = config.lib.file.mkOutOfStoreSymlink config.secrets.files.weechat-sec.path;
  };

  services.weechat.enable = true;

  programs.weechat = {
    enable = true;
    scripts = with pkgs.weechatScripts; [
      weechat-notify-send
    ];
    config = {
      irc = {
        server = {
          softnet = {
            addresses = "kyouko.kittywit.ch/5001";
            password = "kat@${nixos.networking.hostName}/softnet:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
          liberachat = {
            addresses = "kyouko.kittywit.ch/5001";
            password = "kat@${nixos.networking.hostName}/liberachat:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
          espernet = {
            addresses = "kyouko.kittywit.ch/5001";
            password = "kat@${nixos.networking.hostName}/espernet:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
        };
      };
      matrix = {
        server.kittywitch = {
          address = "kittywit.ch";
          device_name = "${nixos.networking.hostName}/weechat";
          username = "kat";
          password = "\${sec.data.matrix}";
        };
      };
    };
  };
}
