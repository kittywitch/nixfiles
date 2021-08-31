{ config, pkgs, meta, ... }:

{
  imports = [
    meta.services.dnscrypt-proxy
    ./adb.nix
    ./fonts.nix
    ./sway.nix
    ./filesystems.nix
    ./qt.nix
    ./gpg.nix
    ./xdg-portals.nix
    ./nfs.nix
    ./mingetty.nix
    ./sound.nix
  ];

  services.tumbler.enable = true;

  deploy.profile.gui = true;
}
