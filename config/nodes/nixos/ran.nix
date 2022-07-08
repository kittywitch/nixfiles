{ meta, config, pkgs, lib, ... }:

with lib;

{
  # Imports

  imports = with meta; [
    profiles.hardware.eeepc-1015pem
    profiles.network
    services.kattv
    services.dnscrypt-proxy
    users.arc
  ];

  # Terraform

  deploy.tf = {
    resources.ran = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.private.nixos.ipv4.address;
      };
    };
  };

  # File Systems and Swap

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/469a684b-eb8f-48a8-8f98-be58528312c4";
      fsType = "ext4";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/2223e305-79c9-45b3-90d7-560dcc45775a"; }];

  # Bootloader

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # Hardware

  services.logind.lidSwitchExternalPower = "ignore";

  # Networking

  networking = {
    hostId = "9f89b327";
    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
  };

  network = {
    addresses = {
      private = {
        enable = true;
        nixos = {
          ipv4.address = "192.168.1.215";
        };
      };
    };
  };

  # Firewall

  network.firewall = {
    public = {
      interfaces = singleton "enp1s0";
    };
  };

  # State

  system.stateVersion = "20.09";
}
