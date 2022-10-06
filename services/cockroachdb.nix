{ config, meta, lib, ... }: let
  inherit (lib.attrsets) mapAttrsToList filterAttrs;
  inherit (lib.strings) concatStringsSep;
in {
  services = {
    cockroachdb = {
      enable = true;
      insecure = true;
      join = concatStringsSep "," (mapAttrsToList (_: nixos:
        "${nixos.networks.tailscale.ipv4}:${builtins.toString nixos.services.cockroachdb.listen.port}"
      ) (filterAttrs (_: nixos: nixos.services.cockroachdb.enable) meta.network.nodes.nixos));
      http = {
        address = config.networks.tailscale.ipv4;
        port = 8973;
      };
      listen = {
        address = config.networks.tailscale.ipv4;
      };
    };
  };
}
