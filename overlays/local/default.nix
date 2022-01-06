final: prev: {
  vips = prev.vips.override { libjxl = null; };
  kat-hugosite = final.callPackage ./kat-hugosite.nix { };
  vfio-vm = final.callPackage ./vm.nix { };
  vfio-vm-pinning = final.callPackage ./vm-pinning.nix { };
  vfio-disk-mapper = final.callPackage ./disk-mapper.nix { };
}
