{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.strings) fileContents;
in {
  home.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";

  # Disable gnome-keyring ssh-agent
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    ${fileContents "${pkgs.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
    Hidden=true
  '';
}
