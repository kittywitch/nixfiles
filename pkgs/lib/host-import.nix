{ lib }: hostName: lib.filter builtins.pathExists [
  (../../config/hosts + "/${hostName}/nixos")
  (../../config/trusted/hosts + "/${hostName}/nixos")
  ../../config/trusted/profile
  ../../config/nixos.nix
]
