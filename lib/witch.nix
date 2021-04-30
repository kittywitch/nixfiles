{ pkgs, lib }:

{
  style = import ./style.nix { inherit pkgs; };
  colorhelpers = import ./colorhelpers.nix { inherit lib; };
  modList = import ./modules.nix;
}
