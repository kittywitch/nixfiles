{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ranger
  ];

  xdg.configFile."ranger/rc.conf".text = ''
    set preview_images true
  '';
}
