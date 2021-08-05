{ lib }: hostName: lib.filter builtins.pathExists [
  (../../config/hosts + "/${hostName}/nixos.nix")
  (../../config/trusted/hosts + "/${hostName}/nixos.nix")
  ../../config/trusted/profile
  ../../config/profiles/base
]
