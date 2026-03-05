{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      twitter-color-emoji
      corefonts
      cozette
      vista-fonts
      open-dyslexic
      ubuntu-sans
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
