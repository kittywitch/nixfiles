{ config, ... }:

{
  imports = [ ./firefox ./packages.nix ./gtk.nix ./foot.nix ./xdg.nix ./ranger.nix ./fonts.nix ];
}
