{
  config,
  tree,
  machine,
  systemType,
  std,
  inputs,
  nur,
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
        inputs.hyprlock.homeManagerModules.default
        inputs.hypridle.homeManagerModules.default
      ]
      ++ list.optional (tree.${systemType} ? home) tree.${systemType}.home;

    users.kat.imports = with tree.home.profiles; [
      common
    ];

    extraSpecialArgs = {
      inherit tree machine std inputs nur;
      parent = config;
    };
  };
}
