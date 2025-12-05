{pkgs, ...}: {
  #boot.zfs.package = pkgs.zfs_cachyos;
  #boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
}
