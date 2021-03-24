{ config, pkgs, lib, superConfig, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    home.file = {
      ".local/share/weechat/sec.conf" = lib.mkIf config.deploy.profile.private {
        source = "${../../../private/files/weechat/sec.conf}";
      };
    };
    programs.weechat = {
      enable = true;
      init = lib.mkBefore ''
        /server add freenode athame.kittywit.ch/5001 -ssl -autoconnect
        /server add espernet athame.kittywit.ch/5001 -ssl -autoconnect
        /matrix server add kat kittywit.ch
      '';
      packageUnwrapped = pkgs.unstable.weechat-unwrapped;
      homeDirectory = "${config.xdg.dataHome}/weechat";
      plugins.python = {
        enable = true;
        packages = [ "weechat-matrix" ];
      };
      scripts = with pkgs.weechatScripts; [
        go
        auto_away
        autosort
        colorize_nicks
        unread_buffer
        urlgrab
        vimode-git
        weechat-matrix
        weechat-notify-send
      ];
      config = {
        weechat = {
          look = { mouse = true; };
          bar = {
            buflist = { size_max = 24; };
            nicklist = { size_max = 18; };
          };
        };
        urlgrab.default.copycmd = "${pkgs.wl-clipboard}/bin/wl-copy";
        plugins.var.python.vimode.copy_clipboard_cmd = "wl-copy";
        plugins.var.python.vimode.paste_clipboard_cmd = "wl-paste --no-newline";
        plugins.var.python.notify_send.icon = "";
        sec = {
          crypt = {
            passphrase_command = ''
              ${pkgs.rbw-bitw}/bin/bitw -p gpg://${
                ../../../private/files/bitw/master.gpg
              } get "weechat"'';
            hash_algo = "sha512";
          };
        };
        irc = {
          look = { server_buffer = "independent"; };
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
          network = {
            max_backlog_sync_events = 30;
            lazy_load_room_users = true;
            autoreconnect_delay_max = 5;
            lag_min-show = 1000;
          };
          look = { server_buffer = "independent"; };
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
  };
}
