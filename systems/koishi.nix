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
        i3
        #sway
        #xfce
        #openbox
        #kde
        #gnome
      ]);
    config = {
      home-manager.users.kat.imports =
        (with tree.home.profiles; [
          graphical
          devops
        ])
        ++ (with tree.home.environments; [
          i3
          #xfce
          #sway
          #kde
          #gnome
        ]);

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/ea521d6e-386f-4e6d-adde-c4be376cf19b";
        fsType = "xfs";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/C6C8-14D2";
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };

      swapDevices = [
        {device = "/dev/disk/by-uuid/7486e618-214b-47ff-87a7-0d53099a05b4";}
      ];

      boot = {
        initrd.luks.devices."cryptmapper".device = "/dev/disk/by-uuid/16296ac6-b8b2-4c4e-94f6-c06ea84d6fbb";
        loader.grub.useOSProber = true;
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
