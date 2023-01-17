{
  lib,
  tree,
  inputs,
  ...
}: let
  inherit (lib.attrsets) mapAttrs;
in
  inputs.utils.lib.eachDefaultSystem (system: {
    devShells = let
      shells = mapAttrs (_: path:
        import path rec {
          inherit tree inputs system;
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          inherit (inputs.nixpkgs) lib;
        })
      tree.shells;
    in
      shells // {default = shells.repo;};
  })
