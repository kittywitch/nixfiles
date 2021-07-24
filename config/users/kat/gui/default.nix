{ config, ... }:

{
  deploy.profile.gui = true;

  imports = [ ./firefox ./packages.nix ./gtk.nix ./wezterm.nix ./foot.nix ./xdg.nix ./ranger.nix ];

  fonts.fontconfig.enable = true;
}
