{
  config,
  tree,
  machine,
  systemType,
  std,
  ...
}: let
  inherit (std) list;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = with tree;
      [
        modules.home
      ]
      ++ list.optional (tree.${systemType} ? home) tree.${systemType}.home;

    users.kat.imports = with tree.kat; [
      common
    ];
    extraSpecialArgs = {
      inherit tree machine std;
      parent = config;
    };
  };
}
