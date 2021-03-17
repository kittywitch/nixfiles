{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ../../services/zfs.nix ];

  deploy.profiles = [ "gui" "sway" "kat" "laptop" "private" ];
  deploy.groups = [ "gui" ];
  deploy.ssh.host = "192.168.1.92";

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

