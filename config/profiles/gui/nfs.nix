{ config, lib, meta, ... }:

{
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/kat-nas" = lib.mkIf (config.networking.hostName != "beltane") {
    device = "${meta.network.nodes.beltane.network.addresses.private.domain}:/mnt/zraw/media";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "nfsvers=4" "soft" "retrans=2" "timeo=60" ];
  };

  /*
    fileSystems."/mnt/hex-corn" = {
    device = "storah.net.lilwit.ch:/data/cornbox";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
    };

    fileSystems."/mnt/hex-tor" = {
    device = "storah.net.lilwit.ch:/data/torrents";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
    };
  */

  systemd.services.nfs-mountd = {
    wants = [ "network-online.target" "yggdrassil.service" ];
  };
}
