{ config, ... }:

{
  base16 = {
    shell.enable = true;
    schemes = [ "atelier.atelier-cave" "atelier.atelier-cave-light" "tomorrow.tomorrow-night-eighties" "tomorrow.tomorrow" ];
    alias.light = "atelier.atelier-cave-light";
    alias.dark = "atelier.atelier-cave";
  };
  #  home.base16-shell = {
  #    enable = true;
  #    defaultTheme = "rebecca.rebecca";
  #  };
}
