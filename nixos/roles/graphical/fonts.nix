{ pkgs, ... }: {
  fonts = {
    fonts = with pkgs; [
      font-awesome
      twitter-color-emoji
      iosevka-bin
    ];
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
}
