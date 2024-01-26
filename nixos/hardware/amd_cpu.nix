{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  boot.kernelModules = ["kvm-amd"];
  hardware.cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
}
