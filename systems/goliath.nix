_: let
  hostConfig = {
    config,
    lib,
    pkgs,
    tree,
    ...
  }: let
    inherit (lib.lists) singleton;
    inherit (lib.attrsets) nameValuePair listToAttrs;
      datasets = [
      "root"
      "nix"
      "games"
      "home"
      "var"
    ];
    datasetEntry = dataset: nameValuePair (if dataset == "root" then "/" else "/${dataset}") {
      device = "zpool/${dataset}";
      fsType = "zfs";
      options = [ "zfsutil" ];
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
    imports = (with tree.nixos.profiles; [
        graphical
        wireless
        gaming
      ])
      ++ (with tree.nixos.environments; [
        hyprland
      ]);

    home-manager.users.kat.imports =
      (with tree.home.profiles; [
        graphical
      ])
      ++ (with tree.home.environments; [
        hyprland
      ]);

    networking.hostId = "c3b94e85";

  home-manager.users.kat.wayland.windowManager.hyprland.settings = {
      monitor = [
    "DP-2, 3840x2160, 0x0, 1"
    "HDMI-A-1, 1920x1080, auto-right, 1"
      ];
      env = [
        "NVD_BACKEND,direct"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NIXOS_OZONE_WL,1"
        "__NV_DISABLE_EXPLICIT_SYNC,1"
        "QT_QPA_PLATFORM,wayland;xcb"
      ];
    };

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
      enable = true;
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
      kernelModules = ["nct6775" "kvm-amd"];
        extraModulePackages = [config.boot.kernelPackages.v4l2loopback.out];
      supportedFilesystems = ["ntfs" "zfs"];
    };

    fileSystems = datasetEntries // {
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
    ];
    system.stateVersion = "21.11";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
