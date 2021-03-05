{ lib }:

{
  style = import ./style.nix;
  colorhelpers = import ./colorhelpers.nix { inherit lib; };
  secrets = import ./secrets.nix;
  modList = import ./modules.nix;
}
