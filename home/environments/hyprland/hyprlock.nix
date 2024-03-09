{ pkgs, ... }: {
  programs.hyprlock = {
    enable = true;
    backgrounds = [
      {
          path = "screenshot";
          blur_size = 8;
          blur_passes = 1;
      }
    ];
  };

}
