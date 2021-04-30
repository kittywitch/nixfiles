{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.tmpOnTmpfs = true;
  services.journald.extraConfig = "SystemMaxUse=512M";
}
