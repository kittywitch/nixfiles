{
  std,
  config,
  lib,
  ...
}: let
  inherit (std) list;
  inherit (lib.modules) mkDefault mkIf;
in {
  boot = mkIf (list.elem "zfs" config.boot.supportedFilesystems) {
    kernelPackages = mkDefault config.boot.zfs.package.latestCompatibleLinuxPackages;
    zfs.enableUnstable = true;
  };
}
