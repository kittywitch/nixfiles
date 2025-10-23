{pkgs, ...}: {
  programs.bottom = {
    enable = true;
    package = pkgs.bottom;
  };
}
