_: let
  hostConfig = {
    lib,
    tree,
    ...
  }: let
    inherit (lib.modules) mkDefault;
  in {
    imports = with tree; [
      nixos.rosetta
      nixos.roles.bootable
    ];

    boot = {
      loader.systemd-boot.enable = true;
      initrd.availableKernelModules = ["virtio_pci" "xhci_pci" "usb_storage" "usbhid"];
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/d91cbfb6-5a09-45d8-b226-fc97c6b09f61";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/FED9-4FD3";
        fsType = "vfat";
      };

      "/run/rosetta" = {
        device = "rosetta";
        fsType = "virtiofs";
      };
    };
    swapDevices = [
      {device = "/dev/disk/by-uuid/fd7d113e-7fed-44fc-8ad7-82080f27cd07";}
    ];

    networking.interfaces.enp0s1.useDHCP = mkDefault true;

    nixpkgs.hostPlatform = mkDefault "aarch64-linux";

    system.stateVersion = "22.11";
  };
in {
  arch = "aarch64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
