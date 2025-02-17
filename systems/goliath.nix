_: let
  hostConfig = {
    config,
    lib,
    tree,
    ...
  }: let
    inherit (lib.lists) singleton;
    drives = {
      root = rec {
        raw = "/dev/disk/by-uuid/ca1a4c5f-3fe2-4259-a078-b49dca804f1a";
        result = {
          device = raw;
          fsType = "ext4";
        };
      };
      boot = rec {
        raw = "/dev/disk/by-uuid/E1BE-2C63";
        result = {
          device = raw;
          fsType = "vfat";
        };
      };
      swap = rec {
        raw = "/dev/disk/by-uuid/d1e46d2a-5e08-444c-b48e-17744c5edcff";
        result = {
          device = raw;
        };
      };
    };
  in {
    imports =
      (with tree.nixos.hardware; [
        ])
      ++ (with tree.nixos.profiles; [
        graphical
        wireless
        gaming
      ])
      ++ (with tree.nixos.environments; [
        kde
      ]);

    home-manager.users.kat.imports =
      (with tree.home.profiles; [
        graphical
        devops
      ])
      ++ (with tree.home.environments; [
        kde
      ]);

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      nvidiaSettings = true;
      modesetting.enable = true;
      open = true;
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      };
      kernelModules = ["nct6775" "kvm-amd"];
      supportedFilesystems = ["ntfs"];
    };

    fileSystems = {
      "/" = drives.root.result;
      "/boot" = drives.boot.result;
    };

    swapDevices = singleton drives.swap.result;

    system.stateVersion = "21.11";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
