{pkgs, ...}: {
  fonts = {
    fonts = with pkgs; [
      font-awesome
      twitter-color-emoji
      iosevka-bin
    ];
  };
}
