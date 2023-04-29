{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    networks = mkOption {
      type = with types;
        attrsOf (submodule ({
          name,
          config,
          ...
        }: {
          options = {
            member_configs = mkOption {
              type = unspecified;
            };
            members = mkOption {
              type = unspecified;
            };
          };
        }));
    };
  };
  config = {
    networks = let
      names = ["gensokyo" "chitei" "internet" "tailscale"];
      network_filter = network: rec {
        member_configs = filterAttrs (_: nodeConfig: nodeConfig.networks.${network}.interfaces != []) config.network.nodes;
        members = mapAttrs (_: nodeConfig: nodeConfig.networks.${network}) member_configs;
      };
      networks' = genAttrs names network_filter;
    in
      networks';
  };
}
