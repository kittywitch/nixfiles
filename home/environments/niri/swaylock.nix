{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      indicator = true;
      clock = true;
      grace = 10;
      fade-in = 2;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      show-failed-attempts = true;
      font = "Monaspace Krypton";
    };
  };
}
