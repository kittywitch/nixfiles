{ lib }:

{
  style = import ./style.nix;
  colorhelpers = import ./colorhelpers.nix { inherit lib; };
  secrets = import ../private/secrets.nix;
  modList = import ./modules.nix;
}
