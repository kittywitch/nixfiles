{ lib }: hostName: with lib; filter builtins.pathExists [
  (../../config/hosts + "/${hostName}/nixos.nix")
  (../../config/trusted/hosts + "/${hostName}/nixos.nix")
  ../../config/trusted/profile
  ../../config/profiles/base
] ++ singleton {
  options.home-manager.users = mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = filter builtins.pathExists [
        (../../config/hosts + "/${hostName}/home.nix")
        (../../config/trusted/hosts + "/${hostName}/home.nix")
      ];
    });
  };
}
