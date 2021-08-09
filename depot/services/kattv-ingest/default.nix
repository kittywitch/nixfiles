{ config, pkgs, lib , ... }:

with lib;

{
  services.nginx.appendConfig = ''
      rtmp {
        server {
          listen [::]:1935 ipv6only=off;
          application stream {
            live on;

            allow publish all;
            allow play all;
          }
        }
      }
  '';

  kw.fw = {
    private.tcp.ports = singleton 1935;
    public.tcp.ports = [ 4953 1935 ];
  };

  systemd.sockets.kattv = {
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "0.0.0.0:4953" ];
    socketConfig = {
      Accept = true;
      Backlog = 0;
      MaxConnections = 1;
    };
  };

  systemd.services."kattv@" = {
    environment = pkgs.kat-tv-ingest.env;
    script = "exec ${pkgs.gst_all_1.gstreamer.dev}/bin/gst-launch-1.0 -e --no-position ${pkgs.lib.gst.pipelineShellString pkgs.kat-tv-ingest.pipeline}";
    after = [ "nginx.service" ];
    description = "RTMP stream of kat cam";
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
