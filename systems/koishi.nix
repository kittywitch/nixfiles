_: let
  hostConfig = {
    tree,
    pkgs,
    utils,
    lib,
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
        neededForBoot =
          if builtins.elem dataset ["home"]
          then true
          else false;
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
        result = {
          device = "/dev/mapper/cryptswap";
          options = ["x-systemd.device-timeout=15s" "nofail" "x-systemd.wants=systemd-cryptsetup@cryptswap.service"];
          randomEncryption = false; # fix hibernation
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
        performance
        secureboot
        tiling
          gaming.minecraft
          gaming.vintagestory
      ])
      ++ (with tree.nixos.environments; [
        #niri
        hyprland
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
          # niri.settings = {
          #   outputs = {
          #     "eDP-1".scale = 1.00;
          #   };
          # };
        };
        wayland.windowManager.hyprland.settings.monitor = [
          "eDP-1, 2256x1504, 0x0, 1"
        ];
        imports =
          (with tree.home.profiles; [
            graphical
            tiling
          ])
          ++ (with tree.home.environments; [
            #niri
            hyprland
          ]);
      };

      fileSystems =
        datasetEntries
        // {
          "/boot" = drives.boot.result;
          "/boot-keystore" = {
            #neededForBoot = true;
            device = "/dev/mapper/boot-keystore";
            fsType = "ext4";
            noCheck = true;
            options = ["ro"];
          };
        };

      systemd.enableEmergencyMode = true;
      boot.initrd = {
        systemd = {
          emergencyAccess = true;
          mounts = let
            inherit (utils) escapeSystemdPath;
            # maybe add a require for the /dev/mapper
            sysrooty = escapeSystemdPath "/sysroot";
            requiredBy = [
              "${sysrooty}.mount"
            ]; #"systemd-cryptsetup@cryptswap.service" ];
            requires = ["systemd-cryptsetup@boot-keystore.service"];
          in [
            {
              where = "/boot-keystore";
              what = "/dev/mapper/boot-keystore";
              type = "ext4";
              options = "ro";
              unitConfig = {
              };
              before = requiredBy;
              wantedBy = requiredBy;
              inherit requires;
              after = requires;
            }
            {
              where = "/sysroot/boot-keystore";
              what = "/boot-keystore";
              type = "none";
              options = "bind";
              unitConfig = {
                RequiresMountsFor = [
                  "/boot-keystore"
                  "/sysroot"
                ];
              };
            }
          ];
        };
        luks.devices = {
          "boot-keystore".device = "/dev/disk/by-uuid/d80f77bb-fd82-43dd-9aa4-05da8d2b6154";
          "cryptswap" = {
            device = "/dev/disk/by-uuid/94948ee7-8c89-4b60-bd8c-68171b488d19";
            keyFile = "/boot-keystore/swapkey";
          };
        };
      };

      environment.etc.crypttab = let
        raw = "/dev/disk/by-uuid/94948ee7-8c89-4b60-bd8c-68171b488d19";
      in {
        mode = "0600";
        text = ''
          cryptswap ${raw} /boot-keystore/swapkey keyfile-timeout=5s
        '';
      };

      #boot.resumeDevice = "/dev/mapper/cryptswap";

      swapDevices = [
        drives.swap.result
      ];

      environment.systemPackages = [
        pkgs.e2fsprogs
      ];

      powerManagement.enable = true;

      boot = {
        loader = {
          #systemd-boot.enable = lib.mkForce false;
        };
        zfs = {
          forceImportRoot = false;
          allowHibernation = true;
        };
        kernelModules = ["cros_ec" "cros_ec_lpcs"];
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
  colmena.tags = [
    "personal"
  ];
  ci.enable = false; # Closure too large
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
