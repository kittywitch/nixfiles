_: let
  hostConfig = {
    config,
    tree,
    ...
  }: {
    imports = with tree.nixos.hardware;
      [
        lenovo-thinkpad-x260
        common-pc-laptop-ssd
      ]
      ++ (with tree.nixos.roles; [
        graphical
        gnome
        laptop
      ])
      ++ (with tree; [
        kat.gui
        kat.gnome
        kat.vscodium
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

    networking.networkmanager.wifi.backend = "iwd";

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
