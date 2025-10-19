{pkgs, ...}: {
  services.scx = {
    enable = true;
    package = pkgs.scx_git.full;
    scheduler = "scx_lavd";
  };
}
