{ ... }:

{
  imports = [
    ./vim
    ./zsh.nix
    ./git.nix
    ./kitty.nix
    ./tmux.nix
    ./base16.nix
    ./xdg.nix
    ./ssh.nix
    ./packages.nix
    ./weechat.nix
    ./inputrc.nix
    ./rink.nix
    ./pass.nix
    ./secrets.nix
  ];

  home.stateVersion = "20.09";
}
