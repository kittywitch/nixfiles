{ config, lib, pkgs, sources, ... }:

{
  #imports = [ (sources.home-manager + "/nixos") ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  services.journald.extraConfig = "SystemMaxUse=512M";
}
