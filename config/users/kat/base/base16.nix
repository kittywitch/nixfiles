{ config, ... }:

{
  base16 = {
    shell.enable = true;
    schemes = [ "tomorrow.tomorrow-night-eighties" ];
  };
  #  home.base16-shell = {
  #    enable = true;
  #    defaultTheme = "rebecca.rebecca";
  #  };
}
