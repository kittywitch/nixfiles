{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix> ];

  boot.initrd.availableKernelModules =
    [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/126049c0-34bd-4d96-a8db-276c5d172abe";
    fsType = "ext4";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/1f19daed-1c51-4b14-bfe8-bd7ea075ed96"; }];

  nix.maxJobs = lib.mkDefault 3;
}
