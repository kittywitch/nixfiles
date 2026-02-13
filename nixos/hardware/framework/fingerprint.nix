{pkgs, ...}: {
  services = {
    fwupd = {
      enable = true;
    };
    fprintd.enable = false;
  };
}
