{ ... }:

let sources = import ../nix/sources.nix;
in {
  imports = [
    ./deploy
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
  ];
}
