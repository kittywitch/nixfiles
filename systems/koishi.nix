_: let
  hostConfig = {config, tree, pkgs, ...}: {
    imports = with tree; [
      nixos.gui
      nixos.bootable
      kat.gui
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

    services.openssh = {
      hostKeys = [
        {
          bits = 4096;
          path = "/var/lib/secrets/${config.networking.hostName}-osh-pk";
          type = "rsa";
        }
        {
          path = "/var/lib/secrets/${config.networking.hostName}-ed25519-osh-pk";
          type = "ed25519";
        }
      ];
      extraConfig = ''
        HostCertificate /var/lib/secrets/${config.networking.hostName}-osh-cert
        HostCertificate /var/lib/secrets/${config.networking.hostName}-ed25519-osh-cert
      '';
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/0d846453-95b4-46e1-8eaf-b910b4321ef0";}
    ];

    home-manager.sharedModules = [
      {
        wayland.windowManager.sway.config.input."2:7:SynPS/2_Synaptics_TouchPad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
          click_method = "clickfinger";
        };
      }
    ];

    hardware = {
      cpu.intel.updateMicrocode = true;
      opengl = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vaapiIntel
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };

    boot = {
      initrd.availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
      kernelModules = [ "kvm-intel" ];
      supportedFilesystems = ["xfs"];
      initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/f0ea08b4-6af7-4d90-a2ad-edd5672a2105";
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
          version = 2;
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
