{ config, pkgs, profiles, ... }:

{
  imports =
    [ ./hw.nix profiles.gui profiles.sway profiles.kat profiles.laptop ];

  deploy.target = "mbp";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  networking.hostId = "d199ad70";
  networking.hostName = "mabon";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  system.stateVersion = "20.09";
}
