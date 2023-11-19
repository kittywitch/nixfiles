{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      font-awesome
      twitter-color-emoji
      iosevka-bin
      monaspace
    ];
    enableDefaultPackages = true;
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
