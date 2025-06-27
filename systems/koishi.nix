_: let
  hostConfig = {
    tree,
    pkgs,
    lib,
    config,
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
        wireless
        laptop
          gaming
          sdr
          #virtualisation
          #secureboot
      ])
      ++ (with tree.nixos.environments; [
      #sway
        #xfce
            #openbox
          hyprland
          #gnome
      ]);
    config = {
      home-manager.users.kat.imports =
        (with tree.home.profiles; [
            graphical
        ])
        ++ (with tree.home.environments; [
        #xfce
        #sway
          hyprland
            #gnome
        ]);

    fileSystems = datasetEntries // {
      "/boot" = drives.boot.result;
    };

    swapDevices = [
        drives.swap.result
    ];
    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
    };

      home-manager.users.kat = {
        wayland.windowManager.hyprland.settings.monitor = [
          "eDP-1, preferred, 0x0, 1"
        ];
      };
      boot = {
        loader.grub.useOSProber = true;
        extraModprobeConfig = "options snd_hda_intel power_save=0";
        extraModulePackages = [config.boot.kernelPackages.v4l2loopback.out];
      };

    services.scx = {
      enable = true;
      package = pkgs.scx_git.full;
      scheduler = "scx_lavd";
    };

    zramSwap.enable = true;

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
  deploy.hostname = "10.1.1.68";
  ci.enable = false; # Closure too large
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
