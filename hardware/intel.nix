{ config, ... }:

/*
  This hardware profile corresponds to any machine which has an Intel processor.
*/

{
  hardware.cpu.intel.updateMicrocode = true;

  boot = {
    kernelModules = [ "kvm-intel" ];
  };
}
