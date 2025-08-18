{
  lib,
  tree,
  inputs,
  std,
  pkgs,
  ...
} @ argy: let
  inherit (std) set;
in
  inputs.flake-utils.lib.eachDefaultSystem (system: {
    devShells = let
      shells = set.map (_: path:
        import path (argy
          // {
            pkgs = pkgs.${system};
          }))
      tree.shells;
    in
      shells // {default = shells.repo;};
  })
