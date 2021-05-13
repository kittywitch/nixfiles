{ tf, config, users, pkgs, lib, profiles, sources, ... }:

with lib;

let
  hexchen = (import sources.nix-hexchen) { };
  hexYgg = filterAttrs (_: c: c.enable)
    (mapAttrs (_: host: host.config.hexchen.network) hexchen.hosts);
in
{
  imports = [
    ./hw.nix
    profiles.gui
    profiles.sway
    users.kat.guiFull
    ../../../services/zfs.nix
    ../../../services/restic.nix
    ../../../services/nginx.nix
    ../../../services/node-exporter.nix
    ../../../services/promtail.nix
    ../../../services/netdata.nix
    ./thermal
    ./transmission.nix
    ./jellyfin.nix
    ./virtualhosts.nix
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

  #hardware.ckb-next = {
  #  enable = true;
  #  package = pkgs.ckb-next;
  #};

  katnet.private.interfaces = singleton "hexnet";
  katnet.public.interfaces = singleton "br";

  katnet.private.tcp.ports = [ 10445 ];

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

  environment.systemPackages = [ pkgs.stepmania pkgs.etterna pkgs.screenstub ];

  # other stuffs
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" "xfs" ];
  networking.hostName = "samhain";
  networking.hostId = "617050fc";
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.firewall.allowPing = true;

  systemd.network = {
    networks.enp34s0 = {
      matchConfig.Name = "enp34s0";
      bridge = singleton "br";
    };
    networks.br = {
      matchConfig.Name = "br";
      address = [ "192.168.1.135/24" ];
      gateway = [ "192.168.1.254" ];
    };
    netdevs.br = {
      netdevConfig = {
        Name = "br";
        Kind = "bridge";
        MACAddress = "00:d8:61:c7:f4:9d";
      };
    };
  };

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

