{ lib, config, users, pkgs, profiles, services, ... }:

with lib;

{
  # Imports

  imports = [
    profiles.hardware.eeepc-1015pem
    profiles.laptop
    services.kattv
  ];

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
    wireless.interfaces = [ "wlp2s0" ];
    interfaces = {
      enp1s0.useDHCP = true;
      wlp2s0.useDHCP = true;
    };
  };

  # Firewall

  kw.fw = {
    public = {
      interfaces = singleton "wlp2s0";
      tcp.ports = [ 9981 9982 ];
    };
  };

  # State

  system.stateVersion = "20.09";
}
