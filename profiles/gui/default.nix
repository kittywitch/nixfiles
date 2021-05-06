{ pkgs, ... }:

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

  deploy.profile.gui = true;
}
