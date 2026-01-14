_: let
  hostConfig = {
    config,
    lib,
    pkgs,
    tree,
    std,
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
        performance
        dev
        tiling
      ])
      ++ (with tree.nixos.environments; [
        hyprland
          #niri
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
            "-rating:e"
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
        # waybar.settings.main = {
        #   modules-right = [
        #     "custom/nvidia-vram"
        #   ];
        #   "custom/nvidia-vram" = {
        #     tooltip = false;
        #     format = "vram {}";
        #     interval = 1;
        #     exec = let
        #       inherit (lib.meta) getExe;
        #       inherit (pkgs) writeShellScriptBin bc;
        #       nvidia-vram = writeShellScriptBin "nvidia-vram" ''
        #           export PATH="$PATH:${lib.makeBinPath [
        #           config.hardware.nvidia.package
        #           bc
        #         ]}"
        #         exec ${../packages/nvidia-vram/nvidia-vram.sh} "$@"
        #       '';
        #     in "${getExe nvidia-vram}";
        #     return-type = "";
        #   };
        # };
         # niri.settings = {
         #   outputs = {
         #     "LG Electronics LG Ultra HD 0x0001AC91" = {
         #       scale = 1.0;
         #       position = {
         #         x = 1920;
         #         y = 0;
         #       };
         #       mode = {
         #         width = 2560;
         #         height = 1440;
         #         refresh = 59.951;
         #       };
         #     };
         #     "Samsung Electric Company SAMSUNG Unknown" = {
         #       position = {
         #         x = 0;
         #         y = 0;
         #       };
         #     };
         #     "PNP(XXX) Beyond TV 0x00010000" = {
         #       mode = {
         #         width = 2560;
         #         height = 1440;
         #         refresh = 119.998;
         #       };
         #     };
         #   };
         #   environment = {
         #     NVD_BACKEND = "direct";
         #     ELECTRON_OZONE_PLATFORM_HINT = "auto";
         #     LIBVA_DRIVER_NAME = "nvidia";
         #     NIXOS_OZONE_WL = "1";
         #     QT_QTA_PLATFORM = "wayland;xcb";
         #   };
         # };
      };
      wayland.windowManager.hyprland.settings = {
        wayland.windowManager.hyprland.settings.workspace = let
              inherit (std) list;
              commonOptions = "gapsin:5,gapsout:5,rounding:true,persistent:true";
            in lib.mkForce (
              ["1,monitor:DP-2,default:true,${commonOptions}"]
              ++ (list.map (
                workspace: "${toString workspace},monitor:DP-2,${commonOptions}"
              ) (list.range 2 10))
              ++ ["11,monitor:HDMI-A-1,default:true,${commonOptions}"]
              ++ (list.map (
                workspace: "${toString workspace},monitor:HDMI-A-1,${commonOptions}"
              ) (list.range 12 20)));
        monitor = [
            "HDMI-A-1, 1920x1080, 0x0, 1"
            "DP-2, 2560x1440, auto-right, 1"
          ];
        env = [
          "NVD_BACKEND,direct"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "LIBVA_DRIVER_NAME,nvidia"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "NIXOS_OZONE_WL,1"
          "QT_QPA_PLATFORM,wayland;xcb"
        ];
      };
      imports =
        (with tree.home.profiles; [
          graphical
          tiling
        ])
        ++ (with tree.home.environments; [
          hyprland
            #niri
        ]);
      };

    networking.hostId = "c3b94e85";

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      nvidiaSettings = true;
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      };
      kernelModules = ["nct6775" "kvm-amd" "k10temp"];
      supportedFilesystems = ["ntfs" "zfs" "exfat"];
    };

    fileSystems =
      datasetEntries
      // {
        # "/mnt/katstore" = {
        #   device = "/dev/disk/by-uuid/659A-0735";
        #   fsType = "exfat";
        #   options = [
        #     "users"
        #     "allow_other"
        #     "nofail"
        #     "exec"
        #       "x-systemd.automount"
        #       "x-systemd.idle-timeout=5m"
        #       "x-systemd.device-timeout=1s"
        #       "x-systemd.mount-timeout=1s"
        #   ];
        # };
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
