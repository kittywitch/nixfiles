{pkgs, ...}: {
  services = {
    gvfs = {
      enable = true;
      package = pkgs.gvfs;
    };
    udisks2.enable = true;
    devmon.enable = true;
  };
}
