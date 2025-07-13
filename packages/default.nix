{
  inputs,
  tree,
  ...
}: _: prev: let
  # formerly final: prev:, but deadnix
  inherit (inputs.std.lib.Std.compat) set;
in
  set.map (_: package: prev.callPackage package {}) (removeAttrs tree.packages ["default"])
