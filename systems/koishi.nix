_: let
  hostConfig = {tree, pkgs, ...}: {
    imports =
      (with tree.nixos.hardware; [
        intel_cpu
        intel_gpu
        uefi
      ])
      ++ (with tree.nixos.profiles; [
        graphical
        wireless
        laptop
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

    environment.systemPackages = with pkgs; [
      parsec-bin
    ];

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/a664de0f-9883-420e-acc5-b9602a23e816";
        fsType = "xfs";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/DEBC-8F03";
        fsType = "vfat";
      };
    };

    networking.networkmanager.wifi.backend = "iwd";

    swapDevices = [
      {device = "/dev/disk/by-uuid/0d846453-95b4-46e1-8eaf-b910b4321ef0";}
    ];

    boot = {
      supportedFilesystems = ["xfs"];
      extraModprobeConfig = "options snd_hda_intel power_save=1 power_save_controller=Y";
      initrd = {
        availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc"];
        luks.devices."cryptroot".device = "/dev/disk/by-uuid/f0ea08b4-6af7-4d90-a2ad-edd5672a2105";
      };
      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        grub = {
          enable = true;
          efiSupport = true;
          devices = ["nodev"];
          extraEntries = ''
            menuentry "Windows" {
              insmod part_gpt
                insmod fat
                insmod search_fs_uuid
                insmod chain
                search --fs-uuid --set=root DEBC-8F03
                chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
          '';
        };
      };
    };

    networking = {
      hostId = "dddbb888";
      useDHCP = false;
    };

    system.stateVersion = "21.11";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
