{ config, pkgs, profiles, users, tf, ... }:

{
  imports = [
    ./hw.nix
    profiles.gui
    profiles.sway
    users.kat.guiFull
    ../../../services/zfs.nix
  ];

  home-manager.users.kat = {
    imports = [
      ../home
    ];
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
    boot.loader.grub.mirroredBoots = [
    { devices = [ "/dev/disk/by-uuid/4520-4E5F" ];
      path = "/boot-fallback"; }
  ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "beltane";
  networking.hostId = "3ef9a419";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  system.stateVersion = "21.05";

}

