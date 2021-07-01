{ config, pkgs, ... }:

{
  home.file = {
    ".xinitrc" = {
      executable = true;
      text = ''
        #!${pkgs.bash}/bin/bash
        exec fvwm
      '';
    };
  };
}
