final: prev: {
  vips = prev.vips.override { libjxl = null; };
  kat-hugosite = final.callPackage ./kat-hugosite.nix { };
  sway-scrot = final.callPackage ./sway-scrot { };
  vfio-vm = final.callPackage ./vm.nix { };
  vfio-vm-pinning = final.callPackage ./vm-pinning.nix { };
  vfio-disk-mapper = final.callPackage ./disk-mapper.nix { };
}
