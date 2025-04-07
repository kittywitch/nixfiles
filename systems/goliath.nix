_: let
  hostConfig = {
    config,
    lib,
    pkgs,
    tree,
    ...
  }: let
    inherit (lib.lists) singleton;
    inherit (lib.attrsets) nameValuePair listToAttrs;
      datasets = [
      "root"
      "nix"
      "games"
      "home"
      "var"
    ];
    datasetEntry = dataset: nameValuePair (if dataset == "root" then "/" else "/${dataset}") {
      device = "zpool/${dataset}";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };
    datasetEntries = listToAttrs (map datasetEntry datasets);

    drives = {
      boot = rec {
        raw = "/dev/disk/by-uuid/C494-AA77";
        result = {
          device = raw;
          fsType = "vfat";
        };
      };
      swap = rec {
        raw = "/dev/disk/by-partuuid/e18a5e2a-4888-4d74-b3af-855a70c6b7f9";
        result = {
          device = raw;
          randomEncryption = true;
        };
      };
    };
  in {
    imports = (with tree.nixos.profiles; [
        graphical
        wireless
        gaming
      ])
      ++ (with tree.nixos.environments; [
        i3
      ]);

    home-manager.users.kat.imports =
      (with tree.home.profiles; [
        graphical
      ])
      ++ (with tree.home.environments; [
        i3
      ]);

    networking.hostId = "c3b94e85";

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      nvidiaSettings = true;
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
    };

    zramSwap.enable = true;

    boot = {
      zfs.requestEncryptionCredentials = true;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      };
      kernelModules = ["nct6775" "kvm-amd"];
      supportedFilesystems = ["ntfs" "zfs"];
    };

    fileSystems = datasetEntries // {
      "/boot" = drives.boot.result;
    };

    swapDevices = [
        drives.swap.result
    ];

    environment.systemPackages = with pkgs; [
      ledfx
      openrgb
      nvtopPackages.nvidia
    ];
    system.stateVersion = "21.11";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
