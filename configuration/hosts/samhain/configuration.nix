{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/common
    ../../profiles/desktop
    ../../profiles/gnome
    ../../profiles/xfce
    ../../profiles/gaming
    ../../profiles/development
    ../../profiles/network
    ../../profiles/yubikey
    ./services/nginx.nix
    ./services/torrenting.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" "xfs" ];

  networking.hostName = "samhain";
  networking.hostId = "617050fc";

  networking.useDHCP = false;
  networking.interfaces.enp34s0.useDHCP = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 445 139 9091 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  system.stateVersion = "20.09";

}

