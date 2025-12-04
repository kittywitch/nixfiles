_: let
  hostConfig = {
    lib,
    modulesPath,
    tree,
    ...
  }: {
    imports =
      [
        (modulesPath + "/profiles/qemu-guest.nix")
      ]
      ++ (with tree.nixos.profiles; [
        server
      ]);

    boot = {
      initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
      kernelModules = ["kvm-amd"];
      loader.grub = {
        enable = true;
        device = [
          "/dev/disk/by-uuid/8B8C-6502"
        ];
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/d7419452-7f03-40f1-ba9b-74d81cf2436a";
        fsType = "xfs";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/8B8C-6502";
        fsType = "vfat";
        options = ["fmask=0777" "dmask=0777"];
      };
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/08b6efda-1bb5-4698-abae-fbfa8bff84fe";}
    ];

    networking = {
      interfaces.ens18.ipv4.addresses = [
        {
          address = "154.12.117.50";
          prefixLength = 27;
        }
      ];
      defaultGateway = "154.12.117.33";
      nameservers = [
        "1.1.1.1"
      ];
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    system.stateVersion = "25.05";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  deploy.hostname = "154.12.117.50";
  colmena.tags = [
    "server"
  ];
  modules = [
    hostConfig
  ];
}
