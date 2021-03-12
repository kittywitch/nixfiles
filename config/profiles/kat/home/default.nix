{ ... }:

{
  imports = [
    ./shell.nix
    ./vim
    ./git.nix
    ./tmux.nix
    ./ssh.nix
    ./packages.nix
  ]; # ./emacs bye emacs lol
}
