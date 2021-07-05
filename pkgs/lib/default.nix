{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
# for internal use...
, super ? if !isOverlayLib then lib else { }
, self ? if isOverlayLib then lib else { }
, before ? if !isOverlayLib then lib else { }
, isOverlayLib ? false
}@args: let
  colorHelpers = import ./color-helpers.nix { inherit lib; };
  lib = before // katlib // self; 
  katlib = with before; with katlib; with self; 
{
  inherit (colorHelpers) hextorgba;
  hostImport = import ./host-import.nix { inherit lib; };
  modList = import ./module-list.nix;
}; in katlib
