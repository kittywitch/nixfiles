{ config, ... }:

{
  wayland.windowManager.sway.extraSessionCommands = ''
    export KITTY_CACHE_DIRECTORY="/tmp/kitty";
  '';
  programs.kitty = {
    enable = true;
    font.name = config.nixfiles.theme.font.termName;
    settings = {
      font_size = "10.0";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      disable_ligatures = "cursor";
    };
  };
}
