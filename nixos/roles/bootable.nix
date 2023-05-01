{
  config,
  lib,
  std,
  ...
}: let
  inherit (lib.modules) mkDefault mkIf mkMerge;
  inherit (std) list;
in {
  boot = mkMerge [
    {
      kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "net.core.rmem_max" = 16777216;
        "net.core.wmem_max" = 16777216;
        "net.ipv4.tcp_rmem" = "4096 87380 16777216";
        "net.ipv4.tcp_wmem" = "4096 65536 16777216";
        "net.ipv4.ip_forward" = mkDefault "1";
        "net.ipv6.conf.all.forwarding" = "1";
      };
      loader = {
        grub.configurationLimit = 8;
        systemd-boot.configurationLimit = 8;
      };
      tmp = {
        tmpfsSize = "80%";
        useTmpfs = true;
      };
    }
    (mkIf (list.elem "zfs" config.boot.supportedFilesystems) {
      kernelPackages = mkDefault config.boot.zfs.package.latestCompatibleLinuxPackages;
      zfs.enableUnstable = true;
    })
  ];
}
