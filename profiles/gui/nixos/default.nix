{ ... }:

{
  imports = [
    ./adb.nix
    ./fonts.nix
    ./gpg.nix
    ./firefox.nix
    ./dns.nix
    ./nfs.nix
    ./nixpkgs.nix
    ./mingetty.nix
    ./sound.nix
  ];

  services.tumbler.enable = true;
}
