_: let
  hostConfig = {
    tree,
    config,
    ...
  }: {
    imports =
      (with tree.nixos.hardware; [
        framework
      ])
      ++ (with tree.nixos.profiles; [
        graphical
        gaming
        wireless
        laptop
        bcachefs
        sdr
        virtualisation
        secureboot
      ])
      ++ (with tree.nixos.environments; [
        kde
      ]);
    config = {
      home-manager.users.kat.imports =
        (with tree.home.profiles; [
          graphical
          devops
        ])
        ++ (with tree.home.environments; [
          kde
        ]);

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/861e8815-9327-4e49-915b-73a3b0bdfa25";
          fsType = "bcachefs";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/DD84-303D";
          fsType = "vfat";
        };
      };

      boot = {
        extraModprobeConfig = "options snd_hda_intel power_save=0";
        extraModulePackages = [config.boot.kernelPackages.v4l2loopback.out];
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

      swapDevices = [
        {device = "/dev/disk/by-uuid/04bd322e-dca0-43b8-b588-cc0ef1b1488e";}
      ];

      boot = {
        supportedFilesystems = ["ntfs" "xfs"];
      };

      networking = {
        useDHCP = false;
      };

      system.stateVersion = "24.05";
    };
  };
in {
  arch = "x86_64";
  ci.enable = false; # Closure too large
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
