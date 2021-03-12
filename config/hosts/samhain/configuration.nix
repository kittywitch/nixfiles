{ config, pkgs, lib, sources, witch, ... }:

{
  imports = [
    ./hardware.nix
    ../../services/zfs.nix
    ../../services/nginx.nix
    ./thermal
    ./vm
    ./torrenting.nix
  ];

  deploy.profiles = [ "gui" "sway" "kat" ];
  deploy.ssh.host = "192.168.1.135";

  # graphics tablet
  services.xserver.wacom.enable = true;

  # other stuffs
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" "xfs" ];
  networking.hostName = "samhain";
  networking.hostId = "617050fc";
  networking.useDHCP = false;
  networking.interfaces.enp34s0.useDHCP = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 80 445 139 9091 ]; # smb transmission
  networking.firewall.allowedUDPPorts = [ 137 138 4010 ]; # smb scream

  system.stateVersion = "20.09";

}

