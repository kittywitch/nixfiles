{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  boot.tmpOnTmpfs = true;
  boot.zfs.enableUnstable = true;
  boot.kernel.sysctl = {
    "net.core.rmem_max" = "16777216";
    "net.core.wmem_max" ="16777216";
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
  };
  services.journald.extraConfig = "SystemMaxUse=512M";
  users.mutableUsers = false;
}
