{config, ...}: {
  home-manager.users.kat.programs.weechat.config.buflist = {
    format = with config.base16.defaultScheme.map.ansiStr; {
      indent = " "; # default "  "
      buffer_current = "\${color:,${base02}}\${format_buffer}";
      hotlist = " \${color:${base0D}}(\${hotlist}\${color:${base0D}})";
      hotlist_highlight = "\${color:${base0E}}";
      hotlist_low = "\${color:${base03}}";
      hotlist_message = "\${color:${base08}}";
      hotlist_none = "\${color:${base05}}";
      hotlist_private = "\${color:${base09}}";
      hotlist_separator = "\${color:${base04}},";
      number = "\${color:${base09}}\${number}\${if:\${number_displayed}?.: }";
    };
    look.use_items = 4;
  };
}
