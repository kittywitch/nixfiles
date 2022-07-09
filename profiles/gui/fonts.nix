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
    cantarell-fonts
    emacs-all-the-icons-fonts
    font-awesome
    cozette
    twitter-color-emoji
  ] ++ map (variant: iosevka-bin.override { inherit variant; } ) [ "" "ss10" "aile" ];
}
