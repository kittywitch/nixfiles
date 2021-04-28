{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  services.journald.extraConfig = "SystemMaxUse=512M";
}
