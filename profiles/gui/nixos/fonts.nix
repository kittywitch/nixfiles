{ config, pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;
  fonts.fonts = with pkgs; [
    font-awesome
    nerdfonts
    iosevka
    emacs-all-the-icons-fonts
  ];
}
