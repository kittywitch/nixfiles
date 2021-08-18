{ config, ... }:

{
  imports = [ ./firefox.nix ./firefox-tst.nix ./packages.nix ./gtk.nix ./foot.nix ./xdg.nix ./ranger.nix ./fonts.nix ];
}
