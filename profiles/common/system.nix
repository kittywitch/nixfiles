{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.tmpOnTmpfs = true;
  boot.zfs.enableUnstable = true;
  services.journald.extraConfig = "SystemMaxUse=512M";
  users.mutableUsers = false;
}
