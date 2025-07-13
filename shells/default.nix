{
  lib,
  tree,
  inputs,
  std,
  pkgs,
  ...
}: let
  inherit (std) set;
in
  inputs.flake-utils.lib.eachDefaultSystem (system: {
    devShells = let
      shells = set.map (_: path:
        import path {
          inherit tree inputs system lib std;
          pkgs = pkgs.${system};
        })
      tree.shells;
    in
      shells // {default = shells.repo;};
  })
