_: let
  hostConfig = {
    lib,
    tree,
    modulesPath,
    ...
  }: {
    imports = with tree.nixos; [
      roles.server
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    boot = {
      loader.grub = {
        enable = true;
        device = "/dev/sda";
        version = 2;
      };
      initrd = {
        availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
        kernelModules = [];
      };
      kernelModules = [];
      extraModulePackages = [];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/5db295ec-a933-4395-b918-ebef6f95d8c3";
      fsType = "ext4";
    };

    swapDevices = [];

    networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

    networking.hostName = "yukari";

    system.stateVersion = "23.05";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
