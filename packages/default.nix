{
  inputs,
  tree,
  ...
}: _: prev: let
  # formerly final: prev:, but deadnix
  inherit (inputs.std.lib) set;
in
  set.map (_: package: prev.callPackage package {}) (removeAttrs tree.packages ["default"])
