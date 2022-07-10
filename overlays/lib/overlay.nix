{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
  # for internal use...
, super ? if !isOverlayLib then lib else { }
, self ? if isOverlayLib then lib else { }
, before ? if !isOverlayLib then lib else { }
, isOverlayLib ? false
}@args:
let
  lib = before // katlib // self;
  katlib = with before; with katlib; with self;
    {
      nodeImport = import ./node-import.nix { inherit lib; };
    };
in
katlib
