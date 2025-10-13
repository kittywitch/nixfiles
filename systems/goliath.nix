_: let
  hostConfig = {
    config,
    lib,
    pkgs,
    tree,
    inputs,
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
    imports =
      (with tree.nixos.profiles; [
        graphical
        quiet-boot
        wireless
        gaming
        dev
      ])
      ++ (with tree.nixos.environments; [
        #hyprland
        niri
      ])
      ++ (with tree.nixos.servers; [
        forgejo-runner
      ])
      ++ (with inputs.nixos-hardware.outputs.nixosModules; [
        common-pc
        common-pc-ssd
        common-cpu-amd
        common-cpu-amd-pstate
        common-cpu-amd-zenpower
        common-gpu-nvidia-nonprime
      ]);

    home-manager.users.kat = {
      programs = {
        obs-studio.package = pkgs.obs-studio.override {
          cudaSupport = true;
        };
        konawall-py.settings = {
          source = "konachan";
          tags = [
            "rating:e"
          ];
        };
        # konawall-py.settings = {
        #   source = "e621";
        #   tags = [
        #     "rating:s"
        #     #"-male/male"
        #     "-overweight_male"
        #     "-five_nights_at_freddy's"
        #     #"touhou"
        #     "-male"
        #     "-large_breasts"
        #     "-scalie"
        #     #"-my_little_pony"
        #     "-sonic_the_hedgehog"
        #     "-amputee"
        #     "-inflation"
        #     "-pool_toy"
        #     "-cuckold"
        #     "-gore"
        #     "-human"
        #     "-animated"
        #     "-hyper"
        #     "-death"
        #     "ratio:>=1.3"
        #     "-muscular_male"
        #     "-model_sheet"
        #   ];
        # };
        waybar.settings.main = {
          modules-right = [
            "custom/nvidia-vram"
          ];
          "custom/nvidia-vram" = {
            tooltip = false;
            format = "vram {}";
            interval = 1;
            exec = let
              inherit (lib.meta) getExe;
              inherit (pkgs) writeShellScriptBin bc;
              nvidia-vram = writeShellScriptBin "nvidia-vram" ''
                  export PATH="$PATH:${lib.makeBinPath [
                  config.hardware.nvidia.package
                  bc
                ]}"
                exec ${../packages/nvidia-vram/nvidia-vram.sh} "$@"
              '';
            in "${getExe nvidia-vram}";
            return-type = "";
          };
        };
        niri.settings = {
          outputs = {
            "LG Electronics LG Ultra HD 0x0001AC91" = {
              scale = 1.0;
              position = {
                x = 1920;
                y = 0;
              };
            };
            "Samsung Electric Company SAMSUNG Unknown" = {
              position = {
                x = 0;
                y = 0;
              };
            };
            "PNP(XXX) Beyond TV 0x00010000" = {
              mode = {
                width = 2560;
                height = 1440;
                refresh = 119.998;
              };
            };
          };
          environment = {
            NVD_BACKEND = "direct";
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
            LIBVA_DRIVER_NAME = "nvidia";
            NIXOS_OZONE_WL = "1";
            QT_QTA_PLATFORM = "wayland;xcb";
          };
        };
      };
      imports =
        (with tree.home.profiles; [
          graphical
        ])
        ++ (with tree.home.environments; [
          #hyprland
          niri
        ]);
    };

    networking.hostId = "c3b94e85";

    programs.ssh.extraConfig = ''
      Host daiyousei-build
          HostName 140.238.156.121
          User root
          IdentityAgent /run/user/1000/gnupg/S.gpg-agent.ssh
    '';
    nix = {
      buildMachines = [
        {
          hostName = "daiyousei-build";
          system = "aarch64-linux";
          protocol = "ssh-ng";
          maxJobs = 100;
          speedFactor = 1;
          supportedFeatures = ["benchmark" "big-parallel" "kvm"];
          mandatoryFeatures = [];
        }
      ];
      distributedBuilds = true;
      extraOptions = ''
        builders-use-substitutes = true
      '';
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      nvidiaSettings = true;
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
    };

    services.scx = {
      enable = false;
      package = pkgs.scx_git.full;
      scheduler = "scx_lavd";
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
      kernelModules = ["nct6775" "kvm-amd" "k10temp"];
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback.out
      ];
      supportedFilesystems = ["ntfs" "zfs"];
    };

    fileSystems =
      datasetEntries
      // {
        "/boot" = drives.boot.result;
      };

    swapDevices = [
      drives.swap.result
    ];

    environment.systemPackages = with pkgs; [
      kdePackages.qttools
      ledfx
      openrgb
      nvtopPackages.nvidia
      nvidia-vaapi-driver
      nv-codec-headers-12
    ];
    system.stateVersion = "21.11";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  colmena.tags = [
    "personal"
  ];
  ci.enable = false; # Closure too large
  modules = [
    hostConfig
  ];
}
