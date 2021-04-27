{ tf, config, pkgs, lib, profiles, sources, witch, ... }:

with lib;

let
  hexchen = (import sources.nix-hexchen) { };
  hexYgg = filterAttrs (_: c: c.enable)
    (mapAttrs (_: host: host.config.hexchen.network) hexchen.hosts);
in {
  imports = [
    ./hw.nix
    profiles.gui
    profiles.sway
    profiles.kat
    ../../../services/zfs.nix
    ../../../services/restic.nix
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

  security.acme.certs."samhain.net.kittywit.ch" = {
    domain = "samhain.net.kittywit.ch";
    dnsProvider = "rfc2136";
    credentialsFile = config.secrets.files.dns_creds.path;
    group = "nginx";
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

  hardware.ckb-next = {
    enable = true;
    package = pkgs.ckb-next;
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

  environment.systemPackages = [ pkgs.idevicerestore pkgs.ckb-next ];

  # other stuffs
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" "xfs" ];
  networking.hostName = "samhain";
  networking.hostId = "617050fc";
  networking.useDHCP = false;
  networking.interfaces.enp34s0.useDHCP = true;
  networking.firewall.allowPing = true;

  networking.firewall.interfaces.enp34s0.allowedTCPPorts = [
    1935 # rtmp
    80 # http
    443 # https
  ];

  networking.firewall.interfaces.hexnet.allowedTCPPorts = [
    80 # http
    443 # https
    32101 # mpv
    443 # https
    111 # nfs
    2049 # nfs
  ];

  networking.firewall.interfaces.enp34s0.allowedUDPPorts = [
    4010 # scream
    111 # nfs
    2049 # nfs
  ];

  networking.firewall.interfaces.hexnet.allowedUDPPorts = [ ];

  networking.firewall.allowedUDPPortRanges = [{
    from = 32768;
    to = 60999;
  }]; # dnla

  services.avahi.enable = true;

  hexchen.network = {
    enable = true;
    pubkey = "a7110d0a1dc9ec963d6eb37bb6922838b8088b53932eae727a9136482ce45d47";
    # if server, enable this and set endpoint:
    listen.enable = false;
    listen.endpoints = [ "tcp://0.0.0.0:0" ];
  };

  system.stateVersion = "20.09";
}

