{ sources, ... }:

{
  imports = [
    ./deploy
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
  ];
}
