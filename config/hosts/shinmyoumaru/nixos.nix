{ config, meta, pkgs, lib, ... }: with lib;

{
  # Imports

  imports = with meta; [
    profiles.base
    ./image.nix
  ];

  nixpkgs.crossOverlays = [
    (import ../../../overlays/pi)
  ];

  boot = {
    kernelModules = mkForce [ "loop" "atkbd" ];
    initrd = {
      includeDefaultModules = false;
      availableKernelModules = mkForce [
        "mmc_block"
        "usbhid"
        "ext4"
        "hid_generic"
        "hid_lenovo"
        "hid_apple"
        "hid_roccat"
        "hid_logitech_hidpp"
        "hid_logitech_dj"
        "hid_microsoft"
      ];
    };
  };

  home-manager.users.kat.programs.neovim.enable = mkForce false;
  home-manager.users.hexchen.programs.vim.enable = mkForce false;
  programs.mosh.enable = mkForce false;

  # Weird Shit

  nixpkgs.crossSystem = systems.examples.raspberryPi // {
    system = "armv6l-linux";
  };

  environment.noXlibs = true;
  documentation.info.enable = false;
  documentation.man.enable = false;
  programs.command-not-found.enable = false;
  security.polkit.enable = false;
  security.audit.enable = false;
  services.udisks2.enable = false;
  boot.enableContainers = false;

  nix = {
    binaryCaches = lib.mkForce [ "https://app.cachix.org/cache/thefloweringash-armv7" ];
    binaryCachePublicKeys = [ "thefloweringash-armv7.cachix.org-1:v+5yzBD2odFKeXbmC+OPWVqx4WVoIVO6UXgnSAWFtso=" ];
  };

  # Terraform

  deploy.tf = {
    resources.shinmyoumaru = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.private.nixos.ipv4.address;
      };
    };
  };

  # Bootloader

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = pkgs.linuxPackages_rpi1;
  };

  # File Systems and Swap

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # Networking

  networking = {
    useDHCP = true;
    interfaces.eno1.ipv4.addresses = singleton {
      inherit (config.network.addresses.private.nixos.ipv4) address;
      prefixLength = 24;
    };
    defaultGateway = config.network.privateGateway;
  };

  network = {
    addresses = {
      private = {
        enable = true;
        nixos = {
          ipv4.address = "192.168.1.33";
          # TODO ipv6.address
        };
      };
    };
    yggdrasil = {
      enable = true;
      pubkey = "0000000000000000000000000000000000000000000000000000";
      listen.enable = false;
      listen.endpoints = [ "tcp://0.0.0.0:0" ];
    };
  };

  # Firewall

  network.firewall = {
    private.interfaces = singleton "yggdrasil";
    public.interfaces = singleton "eno1";
  };

  # State

  system.stateVersion = "21.11";
}
