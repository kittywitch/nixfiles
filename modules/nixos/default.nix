{ sources, lib, ... }:

let hexchen = (import sources.nix-hexchen) { };
in {
  imports = [
    ./deploy
    ./tf-glue
    (sources.pbb-nixfiles + "/modules/nftables")
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
    hexchen.modules.hexnet
  ];

  # stubs for hexchens modules, until more generalized
  options.hexchen.dns = lib.mkOption { };
  options.hexchen.deploy = lib.mkOption { };
}
