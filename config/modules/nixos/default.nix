{ meta, sources, lib, ... }:

{
  imports =
    [
      (import (sources.arcexprs + "/modules")).nixos
      (import (sources.katexprs + "/modules")).nixos
      (import (sources.impermanence + "/nixos.nix"))
      (import sources.anicca).modules.nixos
      ./deploy.nix
      ./monitoring.nix
      ./dyndns.nix
      ./secrets.nix
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
    _module.args.hosts = lib.mapAttrs (_: config: { inherit config; }) meta.network.nodes;
  };
}
