_: let
  hostConfig = {
    tree,
    lib,
    config,
    ...
  }: let
    inherit (lib.attrsets) nameValuePair listToAttrs;
    datasets = [
      "root"
      "nix"
      "games"
      "home"
      "var"
    ];
    datasetEntry = dataset:
      nameValuePair (
        if dataset == "root"
        then "/"
        else "/${dataset}"
      ) {
        device = "zpool/${dataset}";
        fsType = "zfs";
        options = ["zfsutil"];
      };
    datasetEntries = listToAttrs (map datasetEntry datasets);

    drives = {
      boot = rec {
        raw = "/dev/disk/by-uuid/BEDB-489E";
        result = {
          device = raw;
          fsType = "vfat";
        };
      };
      swap = rec {
        raw = "/dev/disk/by-partuuid/cba02f4a-a90d-44e3-81a8-46bb4500112e";
        result = {
          device = raw;
          randomEncryption = true;
        };
      };
    };
  in {
    imports =
      (with tree.nixos.hardware; [
        framework
      ])
      ++ (with tree.nixos.profiles; [
        graphical
        quiet-boot
        wireless
        laptop
        gaming
        performance
      ])
      ++ (with tree.nixos.environments; [
        niri
      ]);
    config = {
      home-manager.users.kat = {
        programs = {
          konawall-py.settings = {
            source = "konachan";
            tags = [
              "rating:s"
            ];
          };
          niri.settings = {
            outputs = {
              "eDP-1".scale = 1.00;
            };
          };
        };
        imports =
          (with tree.home.profiles; [
            graphical
          ])
          ++ (with tree.home.environments; [
            niri
          ]);
      };

      fileSystems =
        datasetEntries
        // {
          "/boot" = drives.boot.result;
        };

      swapDevices = [
        drives.swap.result
      ];

      hardware.framework.enableKmod = false;

      boot = {
        loader = {
          grub.useOSProber = true;
          systemd-boot.enable = lib.mkForce false;
        };
        kernelModules = ["cros_ec" "cros_ec_lpcs"];
        extraModprobeConfig = "options snd_hda_intel power_save=0";
        extraModulePackages = with config.boot.kernelPackages; [
          config.boot.kernelPackages.v4l2loopback.out
          framework-laptop-kmod
        ];
      };

      # optional, useful when the builder has a faster internet connection than yours
      services = {
        printing.enable = true;
        syncthing = {
          enable = true;
          openDefaultPorts = true;
          user = "kat";
          dataDir = "/home/kat";
        };
        hardware.bolt.enable = true;
      };

      boot = {
        supportedFilesystems = ["ntfs" "xfs"];
      };

      networking = {
        hostId = "9ef75c48";
        useDHCP = false;
      };

      system.stateVersion = "24.05";
    };
  };
in {
  arch = "x86_64";
  deploy.hostname = "10.1.1.171";
  colmena.tags = [
    "personal"
  ];
  ci.enable = false; # Closure too large
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
