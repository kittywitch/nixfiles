_: let
  hostConfig = {config, tree, pkgs, ...}: {
    imports = with tree.nixos.hardware; [
      lenovo-thinkpad-x260
      common-pc-laptop-ssd
    ] ++ (with tree.nixos.roles; [
      graphical
      laptop
      bootable
    ]) ++ (with tree; [
      kat.gui
    ]);

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
        HostCertificate /var/lib/secrets/${config.networking.hostName}-osh-ed25519-cert
      '';
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/0d846453-95b4-46e1-8eaf-b910b4321ef0";}
    ];

    boot = {
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
