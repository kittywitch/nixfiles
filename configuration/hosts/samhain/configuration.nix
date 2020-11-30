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

  networking.hostName = "samhain";
  networking.hostId = "617050fc";

  networking.useDHCP = false;
  networking.interfaces.enp34s0.useDHCP = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 445 139 9091 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  services.transmission = {
    enable = true;
    home = "/disk/pool-raw/transmission";
    settings = {
      download-dir = "/disks/pool-raw/Public/Media/";
      incomplete-dir = "/disks/pool-raw/Public/Media/.incomplete";
      incomplete-dir-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,192.168.1.*";
    };
  };

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = samhain
      netbios name = samhain
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      hosts allow = 192.168.1. localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      public = {
        path = "/disks/pool-raw/Public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "transmission";
        "force group" = "transmission";
      };
    };
  };

  system.stateVersion = "20.09";

}

