{ config, ... }:

{
  imports = [ ./firefox.nix ./packages.nix ./gtk.nix ./foot.nix ./xdg.nix ./ranger.nix ./fonts.nix ./qt.nix ];
}
