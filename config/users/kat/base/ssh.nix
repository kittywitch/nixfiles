{ meta, config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    hashKnownHosts = true;
    matchBlocks =
      let
        common = {
          forwardAgent = true;
          extraOptions = {
            RemoteForward =
              "/run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra";
          };
          port = 62954;
        };
      in
      (lib.foldAttrList (map
        (network:
          lib.mapAttrs (_: v: { hostname = v.address; } // common) (lib.filterAttrs (_: v: v.enable) (lib.mapAttrs (_: v: v.network.addresses.${network}.ipv4) meta.network.nodes))
        ) [ "private" "public" ]));
  };
}