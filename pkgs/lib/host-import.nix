{ lib }: { hostName, profiles }: with lib; filter builtins.pathExists [
  (../../config/hosts + "/${hostName}/nixos.nix")
  (../../config/trusted/hosts + "/${hostName}/nixos.nix")
] ++ (if builtins.isAttrs profiles.base then profiles.base.imports
else singleton profiles.base) ++ singleton {
  home-manager.users.kat = {
    imports = filter builtins.pathExists [
      (../../config/hosts + "/${hostName}/home.nix")
      (../../config/trusted/hosts + "/${hostName}/home.nix")
    ];
  };
}
