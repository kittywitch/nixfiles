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
      cozette
      twitter-color-emoji
  ];
}
