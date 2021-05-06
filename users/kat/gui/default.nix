{ ... }:

{
  deploy.profile.gui = true;

  imports = [ ./firefox ./kitty.nix ./packages.nix ./weechat.nix ./gtk.nix ];
}
