{config, ...}: {
  boot = {
    blacklistedKernelModules = ["k10temp"];
    extraModulePackages = [config.boot.kernelPackages.zenpower];
    kernelModules = ["zenpower"];
    kernelParams = ["microcode.amd_sha_check=off"];
  };
  services.ucodenix.enable = true;
}
