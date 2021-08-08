{ lib }: { hostName, profiles }: with lib; filter builtins.pathExists [
  (../../config/hosts + "/${hostName}/nixos.nix")
  (../../config/trusted/hosts + "/${hostName}/nixos.nix")
] ++ profiles.base.imports ++ singleton {
  home-manager.users.kat = {
    imports = filter builtins.pathExists [
      (../../config/hosts + "/${hostName}/home.nix")
      (../../config/trusted/hosts + "/${hostName}/home.nix")
    ];
  };
}
