{ config, lib, pkgs, sources, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    home.file.".gnupg/gpg-agent.conf".text = ''
      enable-ssh-support
      pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry
    '';
  };
}
