{
  tree,
  inputs,
  ...
}: let
  overlays = import tree.overlays {inherit inputs tree;};
in
  inputs.utils.lib.eachDefaultSystem (system: {pkgs = import inputs.nixpkgs { inherit system overlays; config.allowUnfree = true; };})
