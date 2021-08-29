{ config, ... }:

{
  imports = [
    ./firefox
    ./packages.nix
    ./gtk.nix
    ./foot.nix
    ./kitty.nix
    ./xdg.nix
    ./ranger.nix
    ./fonts.nix
    ./qt.nix
  ];
}
