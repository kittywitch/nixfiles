let
  pkgs = import ./pkgs { };
  hosts = import ./lib/hosts.nix { inherit pkgs; };
in {
  inherit pkgs;
  inherit (pkgs) lib;
  inherit (hosts) hosts profiles;
  deploy = import ./lib/deploy.nix {
    inherit pkgs;
    inherit (hosts) hosts profiles;
  };
  sources = import ./nix/sources.nix;
}
