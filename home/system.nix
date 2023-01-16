{
  config,
  tree,
  machine,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = with tree; [
      home.modules
      home.common
    ];
    extraSpecialArgs = {
      inherit tree machine;
      nixos = config;
    };
  };
}
