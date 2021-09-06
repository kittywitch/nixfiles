{ config, pkgs, lib, ... }:

with lib;

{
  programs.weechat = {
    init = lib.mkMerge [
      (lib.mkBefore ''
        /server add espernet athame.kittywit.ch/5001 -ssl -autoconnect
        /server add softnet athame.kittywit.ch/5001 -ssl -autoconnect
        /server add liberachat athame.kittywit.ch/5001 -ssl -autoconnect
        /matrix server add kittywitch kittywit.ch
        /key bind meta-g /go
        /key bind meta-v /input jump_last_buffer_displayed
        /key bind meta-c /buffer close
        /key bind meta-n /bar toggle nicklist
        /key bind meta-b /bar toggle buflist
        /relay add weechat 9000
      '')
      (lib.mkAfter ''
        /matrix connect kittywitch
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
      parse_relayed_msg
      colorize_nicks
      unread_buffer
      urlgrab
      vimode-git
      weechat-matrix
      title
      highmon
      zncplayback
    ];
    config = with mapAttrs (_: toString) pkgs.base16.shell.shell256; {
      logger.level.irc = 0;
      logger.level.python.matrix = 0;
      logger.level.core.weechat = 0;
      buflist = {
        format = {
          indent = "\${if:\${merged}?\${if:\${buffer.prev_buffer.number}!=\${buffer.number}?│┌:\${if:\${buffer.next_buffer.number}==\${buffer.number}?│├:\${if:\${buffer.next_buffer.name}=~^server||\${buffer.next_buffer.number}<0?└┴:├┴}}}:\${if:\${buffer.active}>0?\${if:\${buffer.next_buffer.name}=~^server?└:\${if:\${buffer.next_buffer.number}>0?├:└}}:\${if:\${buffer.next_buffer.name}=~^server? :│}}}─";
          buffer_current = "\${color:,${base0D}}\${format_buffer}";
          hotlist = " \${color:${base0B}}(\${hotlist}\${color:${base0B}})";
          hotlist_highlight = "\${color:${base08}}";
          hotlist_low = "\${color:${base06}}";
          hotlist_message = "\${color:${base0C}}";
          hotlist_none = "\${color:${base06}}";
          hotlist_private = "\${color:${base09}}";
          hotlist_separator = "\${color:${base04}},";
          number = "\${color:${base07}}\${number}\${if:\${number_displayed}?.: }";
        };
      };
      weechat = {
        look = {
          mouse = true;
          separator_horizontal = "";
          read_marker_string = "─";
          prefix_same_nick = "↳";
        };
        color = {
          chat_nick_self = base0E;
          separator = base06;
          chat_read_marker = base0B;
          chat_read_marker_bg = base03;
        };
        bar = {
          buflist = {
            size_max = 24;
            color_delim = base0E;
          };
          input = {
            items = "[input_prompt]+(away),[input_search],[input_paste],input_text,[vi_buffer]";
            color_delim = base0E;
            conditions = "\${window.buffer.full_name} != perl.highmon";
          };
          nicklist = {
            size_max = 18;
            color_delim = base0E;
          };
          status = {
            color_bg = base02;
            color_fg = base06;
            color_delim = base0E;
            items = "[time],mode_indicator,[buffer_last_number],[buffer_plugin],buffer_number+:+buffer_name+(buffer_modes)+{buffer_nicklist_count}+matrix_typing_notice+buffer_zoom+buffer_filter,scroll,[lag],[hotlist],completion,cmd_completion";
            conditions = "\${window.buffer.full_name} != perl.highmon";
          };
          title = {
            color_bg = base02;
            color_fg = base06;
            color_delim = base0E;
            conditions = "\${window.buffer.full_name} != perl.highmon";
          };
        };
      };
      urlgrab.default.copycmd = "${pkgs.wl-clipboard}/bin/wl-copy";
      plugins.var = {
        python = {
          title = {
            title_prefix = "weechat - ";
            show_hotlist = true;
            current_buffer_suffix = " [";
            title_suffix = " ]";
          };
          vimode = {
            copy_clipboard_cmd = "wl-copy";
            paste_clipboard_cmd = "wl-paste --no-newline";
            imap_esc_timeout = "100";
            search_vim = true;
            user_mappings = builtins.toJSON {
              "," = "/buffer #{1}<CR>";
              "``" = "/input jump_last_buffer_displayed<CR>";
              "`n" = "/input jump_smart<CR>";
              "k" = "/input history_previous<CR>";
              "j" = "/input history_next<CR>";
              "p" = "a/input clipboard_paste<ICMD><ESC>";
              "P" = "/input clipboard_paste<CR>";
              #"u" = "/input undo<CR>";
              #"\\x01R" = "/input redo<CR>";
              "\\x01K" = "/buffer move -1<CR>";
              "\\x01J" = "/buffer move +1<CR>";
            };
            user_mappings_noremap = builtins.toJSON {
              "\\x01P" = "p";
              "/" = "i/";
            };
            user_search_mapping = "?";
            mode_indicator_cmd_color_bg = base01;
            mode_indicator_cmd_color = base04;
            mode_indicator_insert_color_bg = base01;
            mode_indicator_insert_color = base04;
            mode_indicator_normal_color_bg = base01;
            mode_indicator_normal_color = base04;
            mode_indicator_replace_color_bg = base01;
            mode_indicator_replace_color = base0E;
            mode_indicator_search_color_bg = base0E;
            mode_indicator_search_color = base04;
            no_warn = true;
          };
          notify_send.icon = "";
          go.short_name = true;
        };
        perl = {
          highmon = {
            short_names = "on";
            output = "buffer";
            merge_private = "on";
            alignment = "nchannel,nick";
          };
          parse_relayed_msg = {
            servername = "espernet";
            supported_bot_names = "cord";
          };
        };
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
