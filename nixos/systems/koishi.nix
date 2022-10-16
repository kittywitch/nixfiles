{ meta, config, pkgs, lib, ... }: with lib; {
  imports = with meta; [
    hardware.x270
    hardware.local
    nixos.gui
    nixos.light
    services.nginx
    home.gui
  ];

  config = {
  programs.ssh.extraConfig = ''
    Host daiyousei-build
        HostName ${meta.network.nodes.nixos.daiyousei.networks.internet.uqdn}
        Port 62954
        User root
  '';

virtualisation.docker.enable = true;

services.avahi.enable = true;
environment.systemPackages = [ pkgs.docker-compose ];

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

    swapDevices = [
      { device = "/dev/disk/by-uuid/0d846453-95b4-46e1-8eaf-b910b4321ef0"; }
    ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    
    boot = {
      supportedFilesystems = [ "xfs" ];
      initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/f0ea08b4-6af7-4d90-a2ad-edd5672a2105";
      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        grub = {
          devices = [ "nodev" ];
          efiSupport = true;
          enable = true;
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
    };

    services.fstrim.enable = true;

    networks = {
      gensokyo = {
        interfaces = [ "enp1s0" "wlp3s0" ];
        ipv4 = "10.1.1.65";
        udp = [
          # Chromecast
          [ 32768 60999 ]
          # MDNS
          5353
        ];
      };
    };

    system.stateVersion = "21.11";
  };
}

