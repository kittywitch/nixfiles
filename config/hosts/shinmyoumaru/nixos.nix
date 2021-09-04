{ config, meta, pkgs, lib, ... }: with lib;

{
  # Imports

  imports = with meta; [
    profiles.hardware.raspi
    profiles.base
    ./image.nix
  ];

  home-manager.users.kat.programs.neovim.enable = mkForce false;
  home-manager.users.hexchen.programs.vim.enable = mkForce false;
  programs.mosh.enable = mkForce false;

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
