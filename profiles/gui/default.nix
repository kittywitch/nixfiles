{ config, pkgs, ... }:

{
  imports = [
    ./adb.nix
    ./fonts.nix
    ./gpg.nix
    ./firefox.nix
    ./dns.nix
    ./nfs.nix
    ./mpd.nix
    ./nixpkgs.nix
    ./mingetty.nix
    ./sound.nix
  ];

  hardware.opengl.extraPackages = with pkgs; [ libvdpau-va-gl ];
  services.tumbler.enable = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
  deploy.profile.gui = true;
}
