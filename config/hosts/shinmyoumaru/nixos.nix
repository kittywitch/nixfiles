{ config, meta, pkgs, lib, ... }: with lib;

{
  # Imports

  imports = with meta; [
    profiles.hardware.raspi
    profiles.base
    ./image.nix
  ];

  home-manager.users.kat.programs.neovim.enable = mkForce false;
  programs.mosh.enable = mkForce false;

  # Terraform

  deploy.tf = {
    resources.shinmyoumaru = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = "192.168.1.145"; #config.network.addresses.private.nixos.ipv4.address;
      };
    };
  };

  # Networking

  networking = {
    useDHCP = true;
    interfaces.eth0.ipv4.addresses = singleton {
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
      pubkey = "5ba8c9f8627b6e5da938e6dec6e0a66287490e28084e58125330b7a8812cc22e";
      listen.enable = false;
      listen.endpoints = [ "tcp://0.0.0.0:0" ];
    };
  };

  # Firewall

  network.firewall = {
    private.interfaces = singleton "yggdrasil";
    public.interfaces = singleton "eth0";
  };

  # State

  system.stateVersion = "21.11";
}
