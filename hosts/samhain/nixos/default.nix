{ config, pkgs, lib, profiles, sources, witch, ... }:

{
  imports = [
    ./hw.nix
    profiles.gui
    profiles.sway
    profiles.kat
    ../../../services/zfs.nix
    ../../../services/nginx.nix
    ./thermal
    ./vm
    ./torrenting.nix
  ];

  deploy.groups = [ "gui" ];

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
  networking.firewall.allowedTCPPorts =
    [ 80 443 445 139 9091 5000 32101 ]; # smb transmission mkchromecast
  networking.firewall.allowedUDPPorts = [ 137 138 4010 ]; # smb scream
  networking.firewall.allowedUDPPortRanges = [{
    from = 32768;
    to = 60999;
  } # dnla
    ];
  services.avahi.enable = true;

  system.stateVersion = "20.09";
}

