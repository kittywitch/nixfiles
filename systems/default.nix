{
  inputs,
  tree,
  lib,
  std,
  pkgs,
}: let
  # The purpose of this file is to set up the host module which allows assigning of the system, e.g. aarch64-linux and the builder used with less pain.
  inherit (lib.modules) evalModules;
  inherit (std) set;
  hostConfigs = set.map (name: path:
    evalModules {
      modules = [
        path
        tree.modules.system
      ];
      specialArgs = {
        machine = name;
        inherit name inputs std tree pkgs;
      };
    })
  (set.map (_: c: c) tree.systems);
  processHost = name: cfg: let
    host = cfg.config;
  in
    set.optional (host.type != null) {
      deploy.nodes.${name} = host.deploy;

      "${host.folder}Configurations".${name} = host.built;
    };
in
  {
    systems = hostConfigs;
  }
  // set.merge (set.mapToValues processHost hostConfigs)
