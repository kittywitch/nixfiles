{ config, ... }:

{
  base16 = {
    shell.enable = true;
    schemes = [ "tomorrow.tomorrow-night-eighties" "tomorrow.tomorrow" ];
    alias.light = "tomorrow.tomorrow";
    alias.dark = "tomorrow.tomorrow-night-eighties";
  };
  #  home.base16-shell = {
  #    enable = true;
  #    defaultTheme = "rebecca.rebecca";
  #  };
}
