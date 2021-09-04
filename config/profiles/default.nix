{ lib, tree, ... }@args: with lib;
let
  wrappedBase = base: mapAttrs
    (name: paths: {
      imports = if isAttrs paths then attrValues paths else singleton paths;
    })
    (base);
in
(wrappedBase (filterAttrs (n: v: ! v ? "default") tree.dirs)) // (mapAttrs (n: v: removeAttrs v [ "default" ]) (filterAttrs (n: v: v ? "default") tree.dirs)) // (removeAttrs tree.files [ "default" ])
