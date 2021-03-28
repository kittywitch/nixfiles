{ config, lib, pkgs, witch, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = witch.style.font.name;
    settings = {
      font_size = witch.style.font.size;
      # background = witch.style.base16.color0;
      background_opacity = "0.95";
      # foreground = witch.style.base16.color7;
      # selection_background = witch.style.base16.color7;
      # selection_foreground = witch.style.base16.color0;
      # url_color = witch.style.base16.color3;
      # cursor = witch.style.base16.color7;
      # active_border_color = "#75715e";
      # active_tab_background = "#9900ff";
      # active_tab_foreground = witch.style.base16.color7;
      # inactive_tab_background = "#3a3a3a";
      # inactive_tab_foreground = "#665577";
    }; # // witch.style.base16;
  };
}
