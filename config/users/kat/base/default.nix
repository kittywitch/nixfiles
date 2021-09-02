{ ... }:

{
  imports = [
    ./vim
    ./shell.nix
    ./git.nix
    ./tmux.nix
    ./base16.nix
    ./xdg.nix
    ./ssh.nix
    ./packages.nix
    ./weechat.nix
    ./inputrc.nix
    ./secrets.nix
  ];

  home.stateVersion = "20.09";
}
