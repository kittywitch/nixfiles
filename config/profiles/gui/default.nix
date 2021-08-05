{ config, pkgs, ... }:

{
  imports = [
    ./adb.nix
    ./fonts.nix
    ./sway.nix
    ./fvwm.nix
    ./filesystems.nix
    ./gpg.nix
    ./xdg-portals.nix
    ./dns.nix
    ./nfs.nix
    ./nix-doc.nix
    ./mpd.nix
    ./nixpkgs.nix
    ./mingetty.nix
    ./sound.nix
  ];

  services.tumbler.enable = true;

  deploy.profile.gui = true;
}
