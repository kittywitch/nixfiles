{ config, pkgs, lib, kw, ... }:

{
  hardware.firmware = [ pkgs.libreelec-dvb-firmware ];
  services.tvheadend.enable = true;
  systemd.services.tvheadend.enable = lib.mkForce false;

  kw.fw.public = {
    tcp.ports = [ 9981 9982 ];
  };

  services.nginx.virtualHosts = kw.virtualHostGen {
    networkFilter = [ "private" "yggdrasil" ];
    block = {
      locations."/tvheadend" = {
        proxyPass = "http://127.0.0.1:9981";
        extraConfig = "proxy_pass_header  X-Transmission-Session-Id;";
      };
    };
  };

  systemd.services.tvheadend-kat = {
    description = "Tvheadend TV streaming server";
    wantedBy    = [ "multi-user.target" ];
    after       = [ "network.target" ];
    script   = ''
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
      Type         = "forking";
      PIDFile      = "${config.users.users.tvheadend.home}/tvheadend.pid";
      Restart      = "always";
      RestartSec   = 5;
      User         = "tvheadend";
      Group        = "video";
      ExecStop     = "${pkgs.coreutils}/bin/rm ${config.users.users.tvheadend.home}/tvheadend.pid";
    };
  };
}
