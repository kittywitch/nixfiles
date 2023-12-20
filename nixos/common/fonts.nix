{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      font-awesome
      twitter-color-emoji
      iosevka-bin
      monaspace
    ];
  };
}
