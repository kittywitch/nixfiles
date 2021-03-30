{ config, pkgs, profiles, ... }:

{
  imports = [
    ./hw.nix
    ../../../services/zfs.nix
    profiles.gui
    profiles.sway
    profiles.kat
    profiles.laptop
  ];

  deploy.target = "personal";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "dddbb888";
  networking.hostName = "yule";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.networkmanager.enable = true;

  system.stateVersion = "20.09";
}

