{
  config,
  pkgs,
  std,
  inputs,
  lib,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (std) list set;
in {
  home-manager.users.kat.programs.weechat = {
    plugins = {
      python = {
        enable = true;
      };
    };
    scripts = with inputs.arcexprs.legacyPackages.${pkgs.system}.weechatScripts;
    with pkgs.weechatScripts; [
      colorize_nicks
      title
      weechat-go
      vimode-develop
      auto_away
      weechat-autosort
      urlgrab
      unread_buffer
    ];
    config.plugins.var = {
      #config.plugins.var = with set.map (_: v: "colour${builtins.toString (list.unsafeHead v)}") inputs.base16.lib.base16.shell.mapping256; {
      python = {
        vimode = {
          copy_clipboard_cmd = "wl-copy";
          paste_clipboard_cmd = "wl-paste --no-newline";
          imap_esc_timeout = "100";
          search_vim = true;
          user_mappings = toJSON {
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
          user_mappings_noremap = toJSON {
            "\\x01P" = "p";
            "/" = "i/";
          };
          user_search_mapping = "?";
          #mode_indicator_cmd_color_bg = base01;
          #mode_indicator_cmd_color = base04;
          #mode_indicator_insert_color_bg = base01;
          #mode_indicator_insert_color = base04;
          #mode_indicator_normal_color_bg = base01;
          #mode_indicator_normal_color = base04;
          #mode_indicator_replace_color_bg = base01;
          #mode_indicator_replace_color = base0E;
          #mode_indicator_search_color_bg = base0E;
          #mode_indicator_search_color = base04;
          no_warn = true;
        };
        title = {
          title_prefix = "weechat - ";
          show_hotlist = true;
          current_buffer_suffix = " [";
          title_suffix = " ]";
        };
        notify_send.icon = "";
        go.short_name = true;
      };
    };
  };
}
