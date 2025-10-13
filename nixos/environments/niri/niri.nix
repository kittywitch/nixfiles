{pkgs, ...}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  services.noctalia-shell.enable = true;
}
