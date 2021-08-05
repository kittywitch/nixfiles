{ meta, sources, lib, ... }:

{
  imports = with (import (sources.nixexprs + "/modules")).nixos; [ base16 base16-shared ] ++ [
    ./nftables.nix
    ./firewall.nix
    ./deploy.nix
    ./dns.nix
    ./dyndns.nix
    ./yggdrasil.nix
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
    (sources.hexchen + "/modules/network/yggdrasil")
  ];

  options.hexchen.dns = lib.mkOption { };
  options.hexchen.deploy = lib.mkOption { };

  /*
  This maps hosts to network.nodes from the meta config. This is required for hexchen's yggdrasil network module.
  */
  config = {
    _module.args.hosts = lib.mapAttrs (_: config: { inherit config; } ) meta.network.nodes;
  };
}
