{ meta, tf, config, pkgs, lib, sources, ... }:

with lib;

let
  hexchen = (import sources.hexchen) { };
  hexYgg = filterAttrs (_: c: c.enable)
    (mapAttrs (_: host: host.config.network.yggdrasil) hexchen.hosts);
in
{
  # Imports

  imports = with meta; [
    profiles.hardware.ms-7b86
    profiles.gui
    profiles.vfio
    users.kat.guiFull
    users.kat.services.weechat
    services.nginx
    services.katsplash
    services.restic
    services.zfs
  ];

  # Terraform

  deploy.tf = {
    resources.samhain = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.private.ipv4.address;
      };
    };
  };

  # File Systems and Swap

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

  home-manager.users.kat = {
    secrets = {
      persistentRoot = mkForce "/persist/home/.cache/kat/secrets";
    };

    home.persistence."/persist/home" = {
      allowOther = true;
      directories = [
        ".cache/kat/secrets"
        ".cache/rbw"
        ".local/share/z"
        ".local/share/dino"
        ".local/share/weechat"
        ".local/share/Mumble"
        ".local/share/direnv"
        ".config/Mumble"
        ".config/Element"
        ".password-store"
        ".gnupg"
        ".mozilla"
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

  # Bootloader

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Hardware

  deploy.profile.hardware.acs-override = true;

  users.users.kat.extraGroups = singleton "openrazer";

  hardware.openrazer = {
    enable = true;
  };
  environment.systemPackages = [ pkgs.razergenie ];

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
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0067", GROUP="vfio"
    SUBSYSTEM=="block", ACTION=="add", ATTRS{model}=="HFS256G32TNF-N3A", ATTRS{wwid}=="t10.ATA     HFS256G32TNF-N3A0A                      MJ8BN15091150BM1Z   ", OWNER="kat"
  '';

  # Networking

  networking = {
    hostName = "samhain";
    hostId = "617050fc";
    useDHCP = false;
    useNetworkd = true;
    firewall.allowPing = true;
  };

  systemd.network = {
    networks.enp34s0 = {
      matchConfig.Name = "enp34s0";
      bridge = singleton "br";
    };
    networks.br = {
      matchConfig.Name = "br";
      address = singleton "${config.network.addresses.private.ipv4.address}/24";
      gateway = singleton config.network.privateGateway;
    };
    netdevs.br = {
      netdevConfig = {
        Name = "br";
        Kind = "bridge";
        MACAddress = "00:d8:61:c7:f4:9d";
      };
    };
  };

  services.avahi.enable = true;

  network = {
    addresses = {
      private = {
        enable = true;
        ipv4.address = "192.168.1.1";
      };
    };
    yggdrasil = {
      enable = true;
      pubkey = "a7110d0a1dc9ec963d6eb37bb6922838b8088b53932eae727a9136482ce45d47";
      listen.enable = false;
      listen.endpoints = [ "tcp://0.0.0.0:0" ];
    };
  };

  # Firewall

  network.firewall = {
    public.interfaces = singleton "br";
    private = {
      interfaces = singleton "yggdrasil";
    };
  };

  # State

  system.stateVersion = "20.09";
}

