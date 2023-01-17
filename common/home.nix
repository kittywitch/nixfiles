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
        modules.home
        kat.state
      ]
      ++ optional (tree.${systemType} ? home) tree.${systemType}.home;

    users.kat.imports = with tree.kat; [
      common
    ];
    extraSpecialArgs = {
      inherit tree machine;
      parent = config;
    };
  };
}
