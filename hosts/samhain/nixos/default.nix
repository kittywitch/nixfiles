{ tf, config, pkgs, lib, profiles, sources, witch, ... }:

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

  deploy.target = "personal";

  deploy.tf.variables.dyn_username = {
    type = "string";
    value.shellCommand = "bitw get infra/hexdns-dynamic -f username";
  };

  deploy.tf.variables.dyn_password = {
    type = "string";
    value.shellCommand = "bitw get infra/hexdns-dynamic -f password";
  };

  deploy.tf.variables.dyn_hostname = {
    type = "string";
    value.shellCommand = "bitw get infra/hexdns-dynamic -f hostname";
  };

  secrets.files.kat-glauca-dns = {
    text = ''
      user="${tf.variables.dyn_username.ref}"
      pass="${tf.variables.dyn_password.ref}"
      hostname="${tf.variables.dyn_hostname.ref}"
    '';
    owner = "kat";
    group = "users";
  };

  systemd.services.kat-glauca-dns = {
    serviceConfig = {
      ExecStart = "${pkgs.kat-glauca-dns}/bin/kat-glauca-dns";
    };
    environment = { passFile = config.secrets.files.kat-glauca-dns.path; };
    wantedBy = [ "default.target" ];
  };

  services.usbmuxd.enable = true;

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

  environment.systemPackages = [ pkgs.idevicerestore ];

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

