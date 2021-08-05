{ config, ... }:

/*
This hardware profile corresponds to any machine which has an Intel processor.
*/

{
  deploy.profile.hardware.intel = true;

  boot = {
    kernelModules = [ "kvm-intel" ];
  };
}
