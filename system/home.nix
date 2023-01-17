{
  config,
  tree,
  machine,
  systemType,
  lib,
  ...
}: let
  inherit (lib.lists) optional;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = with tree;
      [
        home.modules
        home.state
      ]
      ++ optional (tree.${systemType} ? home) tree.${systemType}.home;

    users.kat.imports = with tree; [
      home.base
    ];
    extraSpecialArgs = {
      inherit tree machine;
      parent = config;
    };
  };
}
