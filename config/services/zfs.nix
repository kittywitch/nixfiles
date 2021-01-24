{ config, lib, pkgs, ... }:

{
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };
}
