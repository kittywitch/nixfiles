{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      font-awesome
      noto-fonts-cjk-sans
      twitter-color-emoji
      iosevka-bin
      monaspace
      corefonts
      vistafonts
      open-dyslexic
      ubuntu-sans
      jost
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
