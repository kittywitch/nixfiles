{pkgs, ...}: {
  boot.zfs.package = pkgs.zfs_cachyos;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
}
