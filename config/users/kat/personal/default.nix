{ ... }:

{
  imports = [
    ./gpg.nix
    ./git.nix
    ./packages.nix
    ./weechat.nix
    ./email.nix
    ./shell.nix
    ./pass.nix
    ./taskwarrior.nix
    ./bitw.nix
  ];
}
