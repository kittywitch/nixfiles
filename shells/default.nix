{
  lib,
  tree,
  inputs,
  std,
  ...
}: let
  inherit (std) set;
in
  inputs.utils.lib.eachDefaultSystem (system: {
    devShells = let
      shells = set.map (_: path:
        import path rec {
          inherit tree inputs system lib std;
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        })
      tree.shells;
    in
      shells // {default = shells.repo;};
  })
