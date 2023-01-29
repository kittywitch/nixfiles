{ pkgs, ... }: {
  fonts = {
    fonts = (with pkgs; [
      twitter-color-emoji
    ]) ++ (with pkgs.iosevka-comfy; [
      comfy
      comfy-motion
      comfy-wide
    ]);
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
