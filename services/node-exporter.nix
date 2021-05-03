{ config, ... }:

{
  katnet.private.tcp.ports = [ 9002 ];

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
  };
}
