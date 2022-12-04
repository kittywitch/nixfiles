{ config, tree, machine, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      tree.home.modules
      tree.system.modules
    ];
    extraSpecialArgs = {
      inherit tree machine;
      nixos = config;
    };
  };
}
