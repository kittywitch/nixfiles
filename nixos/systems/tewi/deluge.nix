{ config, lib, ... }: let
  inherit (lib) mkAfter;
  cfg = config.services.deluge;
  mediaDir = "/mnt/shadow/deluge";
in {
  sops.secrets.deluge-auth = {
    inherit (cfg) group;
    owner = cfg.user;
  };
  services.deluge = {
    enable = true;
    declarative = true;
    openFirewall = true;
    web = {
      enable = true;
    };
    config = {
      download_location = "${mediaDir}/download";
      move_completed_path = "${mediaDir}/complete";
      move_completed = true;
      max_upload_speed = 10.0;
      #share_ratio_limit = 2.0;
      max_connections_global = 1024;
      max_connections_per_second = 50;
      max_active_limit = 100;
      max_active_downloading = 75;
      max_upload_slots_global = 25;
      max_active_seeding = 1;
      allow_remote = true;
      daemon_port = 58846;
      listen_ports = [ 6881 6889 ];
      random_port = false;
    };
    authFile = config.sops.secrets.deluge-auth.path;
  };
  systemd.services = {
    deluged = {
      unitConfig = {
        RequiresMountsFor = [
          "/mnt/shadow"
        ];
      };
    };
  };
  systemd.tmpfiles.rules = mkAfter [
    # work around https://github.com/NixOS/nixpkgs/blob/8f40f2f90b9c9032d1b824442cfbbe0dbabd0dbd/nixos/modules/services/torrent/deluge.nix#L205-L210
    # (this is dumb, there's no guarantee the disk is even mounted)
    "z '${cfg.config.move_completed_path}' 0775 ${cfg.user} ${cfg.group}"
    "x '${mediaDir}/*'"
  ];
}
