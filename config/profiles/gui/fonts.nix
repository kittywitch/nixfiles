{ config, pkgs, lib, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
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
      emacs-all-the-icons-fonts
      twitter-color-emoji
  ];
}
