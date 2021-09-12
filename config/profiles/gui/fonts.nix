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
    iosevka
    font-awesome
    cozette
    twitter-color-emoji
  ];
}
