{
  inputs,
  tree,
  pkgs,
  ...
}: {
  imports =
    (with tree.nixos.hardware; [
      amd_cpu
      amd_gpu
      uefi
    ])
    ++ [
      inputs.nixos-hardware.outputs.nixosModules.framework-13-7040-amd
    ];
  boot.initrd = {
    availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  };
  services = {
    fwupd = {
      enable = true;
      package =
        (import (builtins.fetchTarball {
            url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
            sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
          }) {
            inherit (pkgs) system;
          })
        .fwupd;
    };
    fprintd.enable = true;
  };
}
