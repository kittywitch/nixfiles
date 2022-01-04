{ config, ... }:

{
  home.file = {
    ".xkb/symbols/us_gbp_map".source = ./layout.xkb;
  };

  home.keyboard = null;
}
