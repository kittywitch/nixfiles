{ config, pkgs, lib, sources, witch, ... }:

{
  imports = [
    ./hw.nix
    ../../../services/zfs.nix
    ../../../services/nginx.nix
    ./thermal
    ./vm
    ./torrenting.nix
  ];

  deploy.profiles = [ "gui" "sway" "kat" "private" ];
  deploy.groups = [ "gui" ];
  deploy.ssh.host = "192.168.1.135";

  secrets.files.kat-glauca-dns = {
    text = pkgs.lib.deployEmbedFuckery ''
      user="$(${pkgs.rbw-bitw}/bin/bitw -p gpg://${../../../private/files/bitw/master.gpg} get infra/hexdns-dynamic -f username)"
      pass="$(${pkgs.rbw-bitw}/bin/bitw -p gpg://${../../../private/files/bitw/master.gpg} get infra/hexdns-dynamic -f password)"
      hostname="$(${pkgs.rbw-bitw}/bin/bitw -p gpg://${../../../private/files/bitw/master.gpg} get infra/hexdns-dynamic -f hostname)"
    '';
    owner = "kat";
    group = "users";
  };

  systemd.services.kat-glauca-dns = {
    serviceConfig = {
      ExecStart = "${pkgs.kat-glauca-dns}/bin/kat-glauca-dns";
    };
    environment = {
      passFile = config.secrets.files.kat-glauca-dns.path;
    };
    wantedBy = [ "default.target"];
  };

  systemd.timers.kat-glauca-dns = {
    timerConfig = {
      Unit = "kat-glauca-dns.service";
      OnBootSec = "5m";
      OnUnitActiveSec = "30m";
    };
    wantedBy = [ "default.target" ];
  };

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
    [ 80 445 139 9091 5000 32101 ]; # smb transmission mkchromecast
  networking.firewall.allowedUDPPorts = [ 137 138 4010 ]; # smb scream
  networking.firewall.allowedUDPPortRanges = [{
    from = 32768;
    to = 60999;
  } # dnla
    ];
  services.avahi.enable = true;

  system.stateVersion = "20.09";
}

