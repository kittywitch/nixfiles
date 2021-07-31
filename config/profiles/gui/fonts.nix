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
      font-awesome
      nerdfonts
      vegur
      creep
      cozette
      emacs-all-the-icons-fonts
      twitter-color-emoji
  ];
}
