{ config, pkgs, ... }:

/*
This hardware profile corresponds to any machine which has an AMD Ryzen processor.
*/

{
  deploy.profile.hardware.ryzen = true;

  boot = {
    kernelModules = [
      "msr"
      "ryzen_smu"
      "kvm-amd"
    ];
    kernelParams = [ "amd_iommu=on" ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    ryzen-smu-monitor_cpu
    ryzen-monitor
  ];
}
