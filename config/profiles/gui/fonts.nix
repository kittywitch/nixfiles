{ config, pkgs, lib, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      allowBitmaps = true;
      defaultFonts = {
        emoji = [
          "Twitter Color Emoji"
        ];
      };
    };
  };

  fonts.fonts = with pkgs; [
    emacs-all-the-icons-fonts
    cozette
    twitter-color-emoji
  ];
}
