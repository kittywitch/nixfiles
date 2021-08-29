{ config, ... }:

{
  wayland.windowManager.sway.extraSessionCommands = ''
      export KITTY_CACHE_DIRECTORY="/tmp/kitty";
  '';
  programs.kitty = {
    enable = true;
    font.name = config.kw.theme.font.termName;
    settings = {
      font_size = toString config.kw.theme.font.size;
      background_opacity = "0.9";
      disable_ligatures = "cursor";
    };
  };
}
