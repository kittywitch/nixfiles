{ config, ... }:

{
  base16 = {
    shell.enable = true;
    schemes = [ "rebecca.rebecca" ];
  };
  #  home.base16-shell = {
  #    enable = true;
  #    defaultTheme = "rebecca.rebecca";
  #  };
}
