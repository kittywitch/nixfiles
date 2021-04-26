{ config, ... }:

{
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/kat-nas" = {
    device = "samhain.net.kittywit.ch:/mnt/zraw/media";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };

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
}
