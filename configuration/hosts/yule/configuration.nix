{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/common
    ../../profiles/desktop
    ../../profiles/gnome
    ../../profiles/gaming
    ../../profiles/development
    ../../profiles/network
    ../../profiles/yubikey
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostId = "dddbb888";
  networking.hostName = "yule";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  system.stateVersion = "20.09";
}

