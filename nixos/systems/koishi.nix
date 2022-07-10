{ meta, config, pkgs, lib, ... }: with lib; {
  imports = with meta; [
    hardware.x270
    nixos.gui
    nixos.light
    nixos.network
    home.gui
  ];

  config = {
    deploy.tf = {
      resources.koishi = {
        provider = "null";
        type = "resource";
        connection = {
          port = head config.services.openssh.ports;
          host = config.network.addresses.private.nixos.ipv4.address;
        };
      };
    };

    programs.ssh.extraConfig = ''
Host daiyousei-build
        HostName daiyousei.kittywit.ch
        Port 62954
        User root
  '';

  nix.buildMachines = [ {
	 hostName = "daiyousei-build";
	 system = "aarch64-linux";
	 # systems = ["x86_64-linux" "aarch64-linux"];
	 maxJobs = 100;
	 speedFactor = 1;
	 supportedFeatures = [ "benchmark" "big-parallel" "kvm" ];
	 mandatoryFeatures = [ ];
	}] ;
	nix.distributedBuilds = true;
	# optional, useful when the builder has a faster internet connection than yours
	nix.extraOptions = ''
		builders-use-substitutes = true
	'';
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/a664de0f-9883-420e-acc5-b9602a23e816";
        fsType = "xfs";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/DEBC-8F03";
        fsType = "vfat";
      };
    };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/0d846453-95b4-46e1-8eaf-b910b4321ef0"; }
    ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    boot = {
      supportedFilesystems = [ "xfs" "zfs" ];
      initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/f0ea08b4-6af7-4d90-a2ad-edd5672a2105";
      loader = {
 efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      # set $FS_UUID to the UUID of the EFI partition
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root DEBC-8F03
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      version = 2;
    };
      };
    };

    hardware.displays = {
      "eDP-1" = {
        res = "1920x1080";
        pos = "0 0";
      };
    };

    networking = {
      hostId = "dddbb888";
      useDHCP = false;
      /* wireless = {
      enable = true;
      userControlled.enable = true;
      interfaces = singleton "wlp3s0";
      };
      interfaces = {
      wlp3s0.ipv4.addresses = singleton {
      inherit (config.network.addresses.private.nixos.ipv4) address;
      prefixLength = 24;
      };
      }; */
    };

    services.fstrim.enable = true;

    network = {
      addresses = {
        private = {
          enable = true;
          nixos = {
            ipv4.address = "192.168.1.121";
          };
        };
      };
      yggdrasil = {
        enable = true;
        pubkey = "f94d49458822a73d70306b249a39d4de8a292b13e12339b21010001133417be7";
        address = "200:d65:6d74:efba:b185:1f9f:29b6:cb8c";
        listen.enable = false;
        listen.endpoints = [ "tcp://0.0.0.0:0" ];
      };
      firewall = {
        public.interfaces = [ "enp1s0" "wlp3s0" ];
        private.interfaces = singleton "yggdrasil";
      };
    };

    system.stateVersion = "21.11";
  };
}

