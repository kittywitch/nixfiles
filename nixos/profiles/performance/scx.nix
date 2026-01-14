{pkgs, ...}: {
  services.scx = {
    enable = true;
    package = pkgs.scx.full;
    scheduler = "scx_lavd";
  };
}
