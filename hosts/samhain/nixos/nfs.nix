{ config, witch, lib, ... }:

with lib;

{
  katnet.private.tcp.ports = [ 111 2049 ];
  katnet.public.tcp.ports = [ 111 2049 ];

  services.nfs.server.enable = true;
  services.nfs.server.exports =
    "/mnt/zraw/media 192.168.1.0/24(rw) 200::/7(rw) ${witch.secrets.unscoped.ipv6_prefix}(rw)";
}
