{ ... }:

{
  imports = [
    ./shell.nix
    ./neovim
    ./git.nix
    ./tmux.nix
    ./ssh.nix
    ./packages.nix
  ]; # ./emacs bye emacs lol
}
