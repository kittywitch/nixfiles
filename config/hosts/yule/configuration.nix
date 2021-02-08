{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  meta.deploy.profiles =
    [ "desktop" "development" "sway" "gaming" "network" "yubikey" ];
  meta.deploy.ssh.host = "192.168.1.92";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "dddbb888";
  networking.hostName = "yule";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  system.stateVersion = "20.09";
}

