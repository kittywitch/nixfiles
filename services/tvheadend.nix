{ config, pkgs, lib, nixfiles, ... }:

{
  hardware.firmware = [ pkgs.libreelec-dvb-firmware ];
  services.tvheadend.enable = true;
  systemd.services.tvheadend.enable = lib.mkForce false;
  users.users.tvheadend.group = "tvheadend";
  users.groups.tvheadend = {};

  networks.internet = {
    tcp = [
      9981
      9982
      5009
    ];
  };

  systemd.services.antennas = {
    wantedBy = [ "plex.service" ];
    after = [ "tvheadend-kat.service" ];
    serviceConfig = let
    antennaConf = pkgs.writeText "config.yaml" (builtins.toJSON {
      antennas_url = "http://127.0.0.1:5009";
      tvheadend_url = "http://127.0.0.1:9981";
      tuner_count = "6";
    }); in {
      ExecStart = "${pkgs.antennas}/bin/antennas --config ${antennaConf}";
    };
  };

  systemd.services.tvheadend-kat = {
    description = "Tvheadend TV streaming server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      ${pkgs.tvheadend}/bin/tvheadend \
      --http_root /tvheadend \
      --http_port 9981 \
      --htsp_port 9982 \
      -f \
      -C \
      -p ${config.users.users.tvheadend.home}/tvheadend.pid \
      -u tvheadend \
      -g video
    '';
    serviceConfig = {
      Type = "forking";
      PIDFile = "${config.users.users.tvheadend.home}/tvheadend.pid";
      Restart = "always";
      RestartSec = 5;
      User = "tvheadend";
      Group = "video";
      ExecStop = "${pkgs.coreutils}/bin/rm ${config.users.users.tvheadend.home}/tvheadend.pid";
    };
  };
}
