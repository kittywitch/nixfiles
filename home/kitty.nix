{ config, ... }:

{
  wayland.windowManager.sway.extraSessionCommands = ''
    export KITTY_CACHE_DIRECTORY="/tmp/kitty";
  '';
  programs.kitty = {
    enable = true;
    font.name = config.kw.theme.font.termName;
    settings = {
      font_size = "10.0";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      background_opacity = "0.9";
      disable_ligatures = "cursor";
    };
  };
}
