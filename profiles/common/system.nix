{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_5_12;
  boot.tmpOnTmpfs = true;
  boot.zfs.enableUnstable = true;
  services.journald.extraConfig = "SystemMaxUse=512M";
  users.mutableUsers = false;
}
