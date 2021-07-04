{ sources, lib, ... }:

{
  imports = with (import (sources.nixexprs + "/modules")).nixos; [ base16 base16-shared ] ++ [
    ./nftables
    ./fw-abstraction
    ./deploy-tf
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
    (sources.hexchen + "/modules/hexnet")
  ];

  # stubs for hexchens modules, until more generalized
  options.hexchen.dns = lib.mkOption { };
  options.hexchen.deploy = lib.mkOption { };
}
