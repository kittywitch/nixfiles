{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      twitter-color-emoji
      corefonts
      vistafonts
      open-dyslexic
      ubuntu-sans
      monaspace
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
