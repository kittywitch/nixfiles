{ config, pkgs, witch, lib, superConfig, ... }:

{
  programs.weechat = {
    enable = true;
    init = lib.mkMerge [
      (lib.mkBefore ''
        /server add freenode athame.kittywit.ch/5001 -ssl -autoconnect
        /server add espernet athame.kittywit.ch/5001 -ssl -autoconnect
        /matrix server add kat kittywit.ch
        /key bind meta-g /go
        /key bind meta-c /buffer close
        /key bind meta-n /bar toggle nicklist 
        /key bind meta-b /bar toggle buflist
      '')
      (lib.mkAfter "/matrix connect kat")
    ];
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
      weechat-title
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
      plugins.var.python.title.title_prefix = "weechat - ";
      plugins.var.python.title.show_hotlist = true;
      plugins.var.python.title.current_buffer_suffix = " [";
      plugins.var.python.title.title_suffix = " ]";
      plugins.var.python.notify_send.icon = "";
      plugins.var.python.go.short_name = true;
      irc = {
        look = { server_buffer = "independent"; };
        server = {
          freenode = {
            address = "athame.kittywit.ch/5001";
            password = "kat/freenode:${witch.secrets.unscoped.weechat.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
          espernet = {
            address = "athame.kittywit.ch/5001";
            password = "kat/espernet:${witch.secrets.unscoped.weechat.znc}";
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
        look = {
          server_buffer = "independent";
          redactions = "notice";
        };
        server.kat = {
          address = "kittywit.ch";
          device_name = "${superConfig.networking.hostName}/weechat";
          username = "kat";
          password = "${witch.secrets.unscoped.weechat.matrix}";
          autoconnect = true;
        };
      };
    };
  };
}
