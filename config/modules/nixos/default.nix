{ meta, sources, lib, ... }:

{
  imports = with (import (sources.nixexprs + "/modules")).nixos; [ base16 base16-shared ] ++ [
    ./nftables.nix
    ./fw-abstraction.nix
    ./deploy-tf.nix
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
    (sources.hexchen + "/modules/hexnet")
  ];

  # stubs for hexchens modules, until more generalized
  options.hexchen.dns = lib.mkOption { };
  options.hexchen.deploy = lib.mkOption { };

  # shim
  config = {
    _module.args.hosts = lib.mapAttrs (_: config: { inherit config; } ) meta.network.nodes;
  };
}
