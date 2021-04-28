{ config, pkgs, profiles, ... }:

{
  imports = [ ./hw.nix profiles.kat profiles.laptop ];

  deploy.target = "slow";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostId = "9f89b327";
  networking.hostName = "ostara";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  system.stateVersion = "20.09";
}
