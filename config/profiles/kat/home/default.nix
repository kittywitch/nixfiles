{ ... }:

{
  imports = [
    ./zsh
    ./vim
    ./git.nix
    ./tmux.nix
    ./secrets.nix
    ./xdg.nix
    ./ssh.nix
    ./packages.nix
  ]; # ./emacs bye emacs lol
}
