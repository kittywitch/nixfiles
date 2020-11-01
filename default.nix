{
  inherit (import ./lib/deploy.nix) deploy;
  pkgs = import ./pkgs;
}
