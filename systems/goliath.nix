_: let
  hostConfig = {
    config,
    lib,
    tree,
    pkgs,
    ...
  }: let
    inherit (lib.lists) singleton;
    drives = {
      root = {
        raw = "/dev/disk/by-uuid/af144e7f-e35b-49e7-be90-ef7001cc2abd";
        luks = "luks-af144e7f-e35b-49e7-be90-ef7001cc2abd";
        result = {
          device = "/dev/disk/by-uuid/cf7fc410-4e27-4797-8464-a409766928c1";
          fsType = "ext4";
        };
      };
      boot = rec {
        raw = "/dev/disk/by-uuid/D0D8-F8BF";
        result = {
          device = raw;
          fsType = "vfat";
        };
      };
      swap = {
        raw = "/dev/disk/by-uuid/111c4857-5d73-4e75-89c7-43be9b044ade";
        luks = "luks-111c4857-5d73-4e75-89c7-43be9b044ade";
        result = {
          device = "/dev/disk/by-uuid/bebdb14c-4707-4e05-848f-5867764b7c27";
        };
      };
    };
  in {
    imports =
      (with tree.nixos.hardware; [
        amd_cpu
        amd_gpu
        b550m-itx-ac
        uefi
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

    boot = {
      loader = {
        grub = {
          enableCryptodisk = true;
        };
      };
      initrd = {
        luks.devices = {
          ${drives.swap.luks} = {
            device = drives.swap.raw;
            keyFile = "/crypto_keyfile.bin";
          };
          ${drives.root.luks}.device = drives.root.raw;
        };
        #
        secrets = {
          "/crypto_keyfile.bin" = null;
        };
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      };
      kernelModules = ["nct6775"];
      supportedFilesystems = ["ntfs"];
    };

    fileSystems = {
      "/" = drives.root.result;
      "/boot" = drives.boot.result;
    };

    swapDevices = singleton drives.swap.result;

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
        HostCertificate /var/lib/secrets/${config.networking.hostName}-osh-ed25519-cert
      '';
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
