{ lib }: { hostName, profiles }: with lib; filter builtins.pathExists [
  (../../depot/hosts + "/${hostName}/nixos.nix")
  (../../depot/trusted/hosts + "/${hostName}/nixos.nix")
] ++ (if builtins.isAttrs profiles.base then profiles.base.imports
else singleton profiles.base) ++ singleton {
  home-manager.users.kat = {
    imports = filter builtins.pathExists [
      (../../depot/hosts + "/${hostName}/home.nix")
      (../../depot/trusted/hosts + "/${hostName}/home.nix")
    ];
  };
}
