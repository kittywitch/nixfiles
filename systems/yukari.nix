_: let
  hostConfig = {
    lib,
    tree,
    modulesPath,
    ...
  }: let
    inherit (lib.modules) mkDefault;
  in {
    imports =
      [
        (modulesPath + "/profiles/qemu-guest.nix")
      ]
      ++ (with tree.nixos.roles; [
        server
      ])
      ++ (with tree.nixos.servers; [
        web
        postgres
        matrix
        vaultwarden
        minecraft
        grafana-stack
        public-directory
        web-irc-client
      ]);

    boot = {
      loader.grub = {
        enable = true;
        device = "/dev/sda";
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

    networking = {
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];
      hostName = "yukari";
      domain = "gensokyo.zone";
      interfaces = {
        enp1s0 = {
          useDHCP = mkDefault true;
          ipv6.addresses = [
            {
              address = "2a01:4ff:1f0:e7bb::1";
              prefixLength = 64;
            }
          ];
        };
      };
      defaultGateway6 = {
        address = "fe80::1";
        interface = "enp1s0";
      };
    };

    sops.defaultSopsFile = ./yukari.yaml;

    system.stateVersion = "23.05";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
