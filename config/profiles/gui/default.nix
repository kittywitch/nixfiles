{ config, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./sway.nix
    ./filesystems.nix
    ./gpg.nix
    ./xdg-portals.nix
    ./dns.nix
    ./nfs.nix
    ./mingetty.nix
    ./sound.nix
  ];

  services.tumbler.enable = true;

  deploy.profile.gui = true;
}
