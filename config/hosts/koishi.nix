{ meta, config, pkgs, lib, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.x270
    profiles.gui
    profiles.light
    profiles.network
    users.kat.guiFull
    services.dnscrypt-proxy
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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/31bfd91b-bdba-47a9-81bf-c96e0adc88e3";
      fsType = "xfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/89A2-ED28";
      fsType = "vfat";
    };
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/96952382-7f56-46b5-8c84-1f0130f68b63"; }
    ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    boot = {
      supportedFilesystems = singleton "xfs";
      initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/8dd300d3-c432-47b6-8466-55682cd1c1a1";
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
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
      wireless = {
        enable = true;
        userControlled.enable = true;
        interfaces = singleton "wlp3s0";
      };
      interfaces = {
        wlp3s0.ipv4.addresses = singleton {
          inherit (config.network.addresses.private.nixos.ipv4) address;
          prefixLength = 24;
        };
      };
      defaultGateway = config.network.privateGateway;
    };

    network = {
      addresses = {
        private = {
          enable = true;
          nixos = {
            ipv4.address = "192.168.1.3";
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

