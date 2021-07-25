{ config, users, pkgs, lib, profiles, ... }:

with lib;

{
  imports = [
    ./hw.nix
    ../../../services/zfs.nix
    ../../../services/restic.nix
    ../../../services/node-exporter.nix
    ../../../services/promtail.nix
    ../../../services/netdata.nix
    ../../../services/nginx.nix
    profiles.gui
    profiles.sway
    profiles.laptop
    users.kat.guiFull
  ];

  home-manager.users.kat = {
    imports = [
      ../home
    ];
  };

  networking.wireless.interfaces = [ "wlp2s0" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  kw.fw.private.interfaces = singleton "yggdrasil";
  kw.fw.public.interfaces = [ "enp1s0" "wlp2s0" ];

  networking.hostId = "dddbb888";
  networking.hostName = "yule";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  network.yggdrasil = {
    enable = true;
    pubkey = "9779fd6b5bdba6b9e0f53c96e141f4b11ce5ef749d1b9e77a759a3fdbd33a653";
    # if server, enable this and set endpoint:
    listen.enable = false;
    listen.endpoints = [ "tcp://0.0.0.0:0" ];
  };

  system.stateVersion = "20.09";
}

