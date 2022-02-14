{ meta, tf, config, pkgs, lib, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.ms-7b86
    profiles.hardware.razer
    profiles.hardware.bamboo
    profiles.gui
    profiles.x11
    profiles.vfio
    profiles.network
    profiles.cross.aarch64
    profiles.cross.armv6l
    profiles.cross.armv7l
    users.kat.guiX11Full
    users.kat.services.weechat
    services.nginx
    services.katsplash
    services.restic
    services.zfs
  ];


  config = {
    deploy.tf = {
      resources.goliath = {
        provider = "null";
        type = "resource";
        connection = {
          port = head config.services.openssh.ports;
          host = config.network.addresses.private.nixos.ipv4.address;
        };
      };
    };

    boot.supportedFilesystems = [ "zfs" "xfs" ];

    fileSystems = {
      "/" = {
        device = "rpool/ephemeral/root";
        fsType = "zfs";
      };
      "/nix" = {
        device = "rpool/local/nix";
        fsType = "zfs";
      };
      "/home" = {
        device = "rpool/ephemeral/home";
        fsType = "zfs";
      };
      "/persist/root" = {
        device = "rpool/persist/root";
        fsType = "zfs";
        neededForBoot = true;
      };
      "/persist/home" = {
        device = "rpool/persist/home";
        fsType = "zfs";
        neededForBoot = true;
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/AED6-D0D1";
        fsType = "vfat";
      };
      "/mnt/xstore" = {
        device = "/dev/disk/by-uuid/64269102-a278-4919-9118-34e37f4afdb0";
        fsType = "xfs";
      };
    };


    boot.initrd.postDeviceCommands = mkIf (config.fileSystems."/".fsType == "zfs") (mkAfter ''
      zfs rollback -r ${config.fileSystems."/".device}@blank
      zfs rollback -r ${config.fileSystems."/home".device}@blank
    '');

    programs.fuse.userAllowOther = true;

    environment.persistence."/persist/root" = {
      directories = [
        "/var/log"
        "/var/lib/systemd/coredump"
        "/var/lib/acme"
        "/var/lib/yggdrasil"
        "/var/lib/kat/secrets"
      ];
      files = [
        "/etc/machine-id"
        "/etc/nix/id_rsa"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };

    secrets.persistentRoot = mkForce "/persist/root/var/lib/kat/secrets";

    home-manager.users.kat = {
      secrets.persistentRoot = mkForce "/persist/home/.cache/kat/secrets";

      home.persistence."/persist/home" = {
        allowOther = true;
        directories = [
          ".cache/kat/secrets"
          ".cache/rbw"
          ".cache/nix"
          ".local/share/z"
          ".local/share/vim"
          ".local/share/nvim"
          ".local/share/task"
          ".local/share/dino"
          ".local/share/weechat"
          ".local/share/TelegramDesktop"
          ".local/share/Mumble"
          ".local/share/direnv"
          ".config/Mumble"
          ".config/Element"
          ".config/discord"
          ".config/obsidian"
          ".config/hedgedoc"
          ".config/obs-studio"
          ".ApacheDirectoryStudio"
          ".gnupg"
          ".mozilla"
          "neorg"
          "docs"
          "media"
          "mail"
          "projects"
          "shared"
        ];
        files = [
          ".ssh/known_hosts"
          ".zsh_history"
        ];
      };
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/89831a0f-93e6-4d30-85e4-09061259f140"; }
      { device = "/dev/disk/by-uuid/8f944315-fe1c-4095-90ce-50af03dd5e3f"; }
    ];

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    deploy.profile.hardware.acs-override = builtins.getEnv "CI_PLATFORM" == "impure";

    users.users.kat.extraGroups = singleton "openrazer";


    hardware = {
      displays = {
        "HDMI-A-1" = {
          res = "1920x1080";
          pos = "1920 0";
        };
        "DVI-D-1" = {
          res = "1920x1200";
          pos = "3840 0";
        };
        "DP-1" = {
          res = "1920x1080";
          pos = "0 0";
        };
      };
      bamboo.display = "HDMI-A-1";
      openrazer.enable = true;
    };

    environment.systemPackages = [
      pkgs.razergenie
    ];

    boot.modprobe.modules = {
      vfio-pci =
        let
          vfio-pci-ids = [
            "1002:67df"
            "1002:aaf0" # RX 580
            "1912:0014" # Renesas USB 3
            "1022:149c" # CPU USB 3
          ];
        in
        mkIf (vfio-pci-ids != [ ]) {
          options.ids = concatStringsSep "," vfio-pci-ids;
        };
        kvm_amd.options = {
          avic = true;
          npt = true;
        };
      };

      deploy.profile.i3 = true;

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0067", GROUP="vfio"
      SUBSYSTEM=="block", ACTION=="add", ATTRS{model}=="HFS256G32TNF-N3A", ATTRS{wwid}=="t10.ATA     HFS256G32TNF-N3A0A                      MJ8BN15091150BM1Z   ", OWNER="kat"
    '';

    services.xserver= {
      extraConfig = ''
        Section "Monitor"
          Identifier "DisplayPort-0"
          Option "PreferredMode" "1920x1080"
          Option "Position" "0 0"
        EndSection
        Section "Monitor"
          Identifier "HDMI-A-0"
          Option "Primary" "true"
          Option "PreferredMode" "1920x1080"
          Option "Position" "1920 0"
        EndSection
        Section "Monitor"
          Identifier "DVI-D-0"
          Option "PreferredMode" "1920x1200"
          Option "Position" "3840 0"
        EndSection
      '';
      deviceSection = ''
        Option "monitor-HDMI-A-0" "HDMI-A-0"
        Option "monitor-DisplayPort-0" "DisplayPort-0"
        Option "monitor-DVI-D-0" "DVI-D-0"
        BusID "PCI:37:0:0"
      '';
    };


    environment.etc = {
      "sensors3.conf".text = ''
        chip "nct6797-isa-0a20"
            label in0 "Vcore"
            label in1 "+5V"
            compute in1 5*@, @/5
            label in2 "AVCC"
            set in2_min 3.3 * 0.90
            set in2_max 3.3 * 1.10
            label in3 "+3.3V"
            set in3_min 3.3 * 0.90
            set in3_max 3.3 * 1.10
            label in4 "+12V"
            compute in4 12*@, @/12
            label in5 "DIMM"
            compute in5 (8+18/19)*@, @/(8+18/19)
            # label in6 "wtf?" # can't find this in hwinfo64?
            label in7 "3VSB"
            set in7_min 3.3 * 0.90
            set in7_max 3.3 * 1.10
            label in8 "Vbat"
            set in8_min 3.3 * 0.90
            set in8_max 3.3 * 1.10
            label in9 "VTT"
            ignore in10 # always zero
            # label in11 "VIN4" # on hwinfo64
            label in12 "SoC" # "CPU NB"  on hwinfo64
            # label in13 "VIN6" # on hwinfo64
            # label in13 "VIN7" # on hwinfo64
            label fan1 "Rear Fan" # "Pump Fan"
            label fan2 "CPU Fan"
            label fan3 "Top Exhaust" # "Case Fan 1"
            label fan4 "Front Fan" # "Case Fan 2"
            label fan5 "Top Intake" # "Case Fan 3"
            label fan6 "Front Fan" # "Case Fan 4"
            label temp7 "Core"
            label temp1 "Motherboard"
            label temp2 "CPU"
            label temp3 "System" # Auxillary
            ignore temp4
            ignore temp6
            ignore temp8
            ignore temp9
            ignore temp10
            ignore intrusion0
            ignore intrusion1
            ignore beep_enable
      '';
    };


    networking = {
      hostId = "617050fc";
      useDHCP = false;
      /*useNetworkd = true;*/
        interfaces = {
          enp34s0.ipv4.addresses = singleton {
            inherit (config.network.addresses.private.nixos.ipv4) address;
            prefixLength = 24;
          };
        };
        defaultGateway = config.network.privateGateway;
      firewall.allowPing = true;
    };

    /* boot.kernel.sysctl = let
      nct = ".//.//.sys.devices.platform.nct6775/2592.hwmon.hwmon1";
    in {
      # rear exhaust
      #"${nct}.pwm1_mode" = 0;
      "${nct}.pwm1_temp_sel" = 2;
      "${nct}.pwm1_enable" = 5;
      "${nct}.pwm1_auto_point1_temp" = 35000;
      "${nct}.pwm1_auto_point1_pwm" = 88;
      "${nct}.pwm1_auto_point2_temp" = 38000;
      "${nct}.pwm1_auto_point2_pwm" = 104;
      "${nct}.pwm1_auto_point3_temp" = 47000;
      "${nct}.pwm1_auto_point3_pwm" = 144;
      "${nct}.pwm1_auto_point4_temp" = 49000;
      "${nct}.pwm1_auto_point4_pwm" = 224;
      "${nct}.pwm1_auto_point5_temp" = 52000;
      "${nct}.pwm1_auto_point5_pwm" = 255;
      "${nct}.pwm1_step_up_time" = 150;
      "${nct}.pwm1_step_down_time" = 150;

      # cpu fan
      #${nct}.pwm2_mode=0
      "${nct}.pwm2_temp_sel" = 2;
      "${nct}.pwm2_enable" = 5;
      "${nct}.pwm2_auto_point1_temp" = 34000;
      "${nct}.pwm2_auto_point1_pwm" = 0;
      "${nct}.pwm2_auto_point2_temp" = 34500;
      "${nct}.pwm2_auto_point2_pwm" = 128;
      "${nct}.pwm2_auto_point3_temp" = 47000;
      "${nct}.pwm2_auto_point3_pwm" = 160;
      "${nct}.pwm2_auto_point4_temp" = 49000;
      "${nct}.pwm2_auto_point4_pwm" = 224;
      "${nct}.pwm2_auto_point5_temp" = 52000;
      "${nct}.pwm2_auto_point5_pwm" = 255;
      "${nct}.pwm2_step_up_time" = 50;
      "${nct}.pwm2_step_down_time" = 50;

      # top exhaust
      #"${nct}.pwm3_mode" = 0;
      "${nct}.pwm3_temp_sel" = 2;
      "${nct}.pwm3_enable" = 5;
      "${nct}.pwm3_auto_point1_temp" = 36000;
      "${nct}.pwm3_auto_point1_pwm" = 0;
      "${nct}.pwm3_auto_point2_temp" = 39000;
      "${nct}.pwm3_auto_point2_pwm" = 136;
      "${nct}.pwm3_auto_point3_temp" = 48000;
      "${nct}.pwm3_auto_point3_pwm" = 144;
      "${nct}.pwm3_auto_point4_temp" = 50000;
      "${nct}.pwm3_auto_point4_pwm" = 176;
      "${nct}.pwm3_auto_point5_temp" = 53000;
      "${nct}.pwm3_auto_point5_pwm" = 255;
      "${nct}.pwm3_step_up_time" = 100;
      "${nct}.pwm3_step_down_time" = 100;

      # front 1
      #"${nct}.pwm4_mode" = 0;
      "${nct}.pwm4_temp_sel" = 2;
      "${nct}.pwm4_enable" = 5;
      "${nct}.pwm4_auto_point1_temp" = 35000;
      "${nct}.pwm4_auto_point1_pwm" = 104;
      "${nct}.pwm4_auto_point2_temp" = 38000;
      "${nct}.pwm4_auto_point2_pwm" = 176;
      "${nct}.pwm4_auto_point3_temp" = 47000;
      "${nct}.pwm4_auto_point3_pwm" = 192;
      "${nct}.pwm4_auto_point4_temp" = 49000;
      "${nct}.pwm4_auto_point4_pwm" = 224;
      "${nct}.pwm4_auto_point5_temp" = 52000;
      "${nct}.pwm4_auto_point5_pwm" = 255;
      "${nct}.pwm4_step_up_time" = 100;
      "${nct}.pwm4_step_down_time" = 100;

      # top intake
      #"${nct}.pwm5_mode" = 0;
      "${nct}.pwm5_temp_sel" = 2;
      "${nct}.pwm5_enable" = 5;
      "${nct}.pwm5_auto_point1_temp" = 36000;
      "${nct}.pwm5_auto_point1_pwm" = 104;
      "${nct}.pwm5_auto_point2_temp" = 39000;
      "${nct}.pwm5_auto_point2_pwm" = 144;
      "${nct}.pwm5_auto_point3_temp" = 48000;
      "${nct}.pwm5_auto_point3_pwm" = 176;
      "${nct}.pwm5_auto_point4_temp" = 50000;
      "${nct}.pwm5_auto_point4_pwm" = 208;
      "${nct}.pwm5_auto_point5_temp" = 53000;
      "${nct}.pwm5_auto_point5_pwm" = 255;
      "${nct}.pwm5_step_up_time" = 100;
      "${nct}.pwm5_step_down_time" = 100;

      # front 2
      #"${nct}.pwm6_mode" = 0;
      "${nct}.pwm6_temp_sel" = 2;
      "${nct}.pwm6_enable" = 5;
      "${nct}.pwm6_auto_point1_temp" = 35000;
      "${nct}.pwm6_auto_point1_pwm" = 104;
      "${nct}.pwm6_auto_point2_temp" = 38000;
      "${nct}.pwm6_auto_point2_pwm" = 176;
      "${nct}.pwm6_auto_point3_temp" = 47000;
      "${nct}.pwm6_auto_point3_pwm" = 192;
      "${nct}.pwm6_auto_point4_temp" = 49000;
      "${nct}.pwm6_auto_point4_pwm" = 224;
      "${nct}.pwm6_auto_point5_temp" = 52000;
      "${nct}.pwm6_auto_point5_pwm" = 255;
      "${nct}.pwm6_step_up_time" = 100;
      "${nct}.pwm6_step_down_time" = 100;
    }; */
    /*systemd.network = {
      networks.enp34s0 = {
        matchConfig.Name = "enp34s0";
        bridge = singleton "br";
      };
      networks.br = {
        matchConfig.Name = "br";
        address = singleton "${config.network.addresses.private.nixos.ipv4.address}/24";
        gateway = singleton config.network.privateGateway;
      };
      netdevs.br = {
        netdevConfig = {
          Name = "br";
          Kind = "bridge";
          MACAddress = "00:d8:61:c7:f4:9d";
        };
      };
    };*/

    services.avahi.enable = true;

    network = {
      addresses = {
        private = {
          enable = true;
          nixos = {
            ipv4.address = "192.168.1.1";
          };
        };
      };
      yggdrasil = {
        enable = true;
        pubkey = "9604cc51760376fa111e931aad1a71ab91f240517a7d60932c6646104b99db47";
        address = "200:d3f6:675d:13f9:120b:ddc2:d9ca:a5cb";
        listen.enable = false;
        listen.endpoints = [ "tcp://0.0.0.0:0" ];
      };
      firewall = {
        public = {
          interfaces = [ "br" "enp34s0" ];
        };
        private = {
          interfaces = singleton "yggdrasil";
          tcp = {
            ports = [
              8096
            ];
            ranges = [{
              from = 32768;
              to = 60999;
            }];
          };
        };
      };
    };

    system.stateVersion = "21.11";
  };
}
