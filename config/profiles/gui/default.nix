{ config, pkgs, ... }:

{
  imports = [
    ./adb.nix
    ./fonts.nix
    ./gpg.nix
    ./firefox.nix
    ./dns.nix
    ./nfs.nix
    ./nix-doc.nix
    ./mpd.nix
    ./nixpkgs.nix
    ./mingetty.nix
    ./sound.nix
  ];

  hardware.opengl.extraPackages = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
  services.tumbler.enable = true;
  environment.systemPackages = with pkgs; [ ntfs3g exfat-utils ];
  
  deploy.profile.gui = true;
}
