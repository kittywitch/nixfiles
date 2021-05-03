{ config, lib, pkgs, ... }:

{
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      frequent = 1;
      daily = 7;
      weekly = 1;
      monthly = 1;
    };
  };
}
