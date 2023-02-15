{ inputs, tree, ... }: final: prev: let
  inherit (inputs.std.lib) set list;
in set.map (_: package: prev.callPackage package {} ) (removeAttrs tree.packages ["default"])
