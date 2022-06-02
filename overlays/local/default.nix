final: prev: {
  vips = prev.vips.override { libjxl = null; };
  sway-scrot = final.callPackage ./sway-scrot { };
  vfio-vm = final.callPackage ./vm.nix { };
  vfio-vm-pinning = final.callPackage ./vm-pinning.nix { };
  vfio-disk-mapper = final.callPackage ./disk-mapper.nix { };
  xbackbone = final.callPackage ./xbackbone.nix { };
  waybar-gpg = final.callPackage ./waybar-gpg { };
  waybar-konawall = final.callPackage ./waybar-konawall { };
  hedgedoc-cli = final.callPackage ./hedgedoc-cli.nix { };
  gensokyoZone = final.callPackage ./gensokyoZone { };
}
