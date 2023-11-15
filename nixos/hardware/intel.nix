{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.machine.cpuVendor == "intel") {
    boot.kernelModules = ["kvm-intel"];
  };
}
