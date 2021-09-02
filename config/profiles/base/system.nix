{ config, lib, pkgs, ... }: with lib;

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  boot.tmpOnTmpfs = true;
  boot.zfs.enableUnstable = mkIf (elem "zfs" config.boot.supportedFilesystems) true;
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = "524288";
    "net.core.rmem_max" = "16777216";
    "net.core.wmem_max" = "16777216";
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
  };
  services.journald.extraConfig = "SystemMaxUse=512M";
  users.mutableUsers = false;
}
