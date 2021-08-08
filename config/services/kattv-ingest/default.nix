{ config, pkgs, lib , ... }:

with lib;

{
  kw.fw.public.tcp.ports = [ 4953 1935 ];

  systemd.sockets.kattv = {
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
    wantedBy = [ "multi-user.target" ];
    after = [ "nginx.service" ];
    description = "RTMP stream of kat cam";
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
