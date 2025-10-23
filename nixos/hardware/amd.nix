{config, ...}: {
  boot = {
    blacklistedKernelModules = ["k10temp"];
    extraModulePackages = [config.boot.kernelPackages.zenpower];
    kernelModules = ["zenpower"];
  };
  services.ucodenix.enable = true;
}
