{ config, pkgs, lib, ... }:

with lib;

{
  programs.weechat = {
    init = lib.mkMerge [
      (lib.mkBefore ''
        /server add espernet athame.kittywit.ch/5001 -ssl -autoconnect
        /matrix server add kat kittywit.ch
        /key bind meta-g /go
        /key bind meta-c /buffer close
        /key bind meta-n /bar toggle nicklist 
        /key bind meta-b /bar toggle buflist
        /relay add weechat 9000
      '')
      (lib.mkAfter ''
        /matrix connect kat
        /window splith +10
        /window 2
        /buffer highmon
        /window 1
      '')
    ];
    homeDirectory = "${config.xdg.dataHome}/weechat";
    plugins.python = {
      enable = true;
      packages = [ "weechat-matrix" ];
    };
    plugins.perl = {
      enable = true;
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
      title
      highmon
    ];
    config = with mapAttrs (_: toString) pkgs.base16.shell.shell256; {
      logger.level.irc = 0;
      logger.level.matrix = 0;
      buflist = {
        format = {
            indent = " "; # default "  "
            buffer_current = "\${color:,${base01}}\${format_buffer}";
            hotlist = " \${color:${base0B}}(\${hotlist}\${color:${base0B}})";
            hotlist_highlight = "\${color:${base0F}}";
            hotlist_low = "\${color:${base06}}";
            hotlist_message = "\${color:${base0E}}";
            hotlist_none = "\${color:${base05}}";
            hotlist_private = "\${color:${base09}}";
            hotlist_separator = "\${color:${base04}},";
            number = "\${color:${base0A}}\${number}\${if:\${number_displayed}?.: }";
        };
      };
      weechat = {
        look = {
          mouse = true;
          separator_horizontal = "";
          read_marker_string = "─";
        };
        color = {
          chat_nick_self = base0F;
          separator = base0A;
          chat_read_marker = base0D;
          chat_read_marker_bg = base03;
        };
        bar = {
          buflist = {
            size_max = 24;
            color_delim = base0A;
          };
          input = {
            items = "[input_prompt]+(away),[input_search],[input_paste],input_text,[vi_buffer]";
            color_delim = base0A;
            conditions = "\${window.buffer.full_name} != perl.highmon";
          };
          nicklist = {
            size_max = 18;
            color_delim = base0A;
          };
          status = {
            color_bg = base01;
            color_fg = base05;
            color_delim = base0A;
            items = "[time],mode_indicator,[buffer_last_number],[buffer_plugin],buffer_number+:+buffer_name+(buffer_modes)+{buffer_nicklist_count}+matrix_typing_notice+buffer_zoom+buffer_filter,scroll,[lag],[hotlist],completion,cmd_completion";
            conditions = "\${window.buffer.full_name} != perl.highmon";
          };
          title = {
            color_bg = base01;
            color_fg = base05;
            color_delim = base0A;
            conditions = "\${window.buffer.full_name} != perl.highmon";
          };
          highmon = {
            position = "top";
            color_delim = base0A;
          };
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
      plugins.var.perl.highmon = {
        short_names = "on";
        output = "buffer";
      };
      irc = {
        look = {
          server_buffer = "independent";
          color_nicks_in_nicklist = true;
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
      };
    };
  };
}
