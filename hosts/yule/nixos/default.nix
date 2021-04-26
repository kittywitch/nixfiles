{ config, pkgs, profiles, ... }:

{
  imports = [
    ./hw.nix
    ../../../services/zfs.nix
    ../../../services/restic.nix
    profiles.gui
    profiles.sway
    profiles.kat
    profiles.laptop
  ];

  deploy.target = "personal";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "dddbb888";
  networking.hostName = "yule";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.networkmanager.enable = true;

  hexchen.network = {
    enable = true;
    pubkey = "9779fd6b5bdba6b9e0f53c96e141f4b11ce5ef749d1b9e77a759a3fdbd33a653";
    # if server, enable this and set endpoint:
    listen.enable = false;
    listen.endpoints = [ "tcp://0.0.0.0:0" ];
  };

  deploy.tf.dns.records.kittywitch_net_yule = {
    tld = "kittywit.ch.";
    domain = "${config.networking.hostName}.net";
    aaaa.address = config.hexchen.network.address;
  };

  system.stateVersion = "20.09";
}

