{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
  # for internal use...
, super ? if !isOverlayLib then lib else { }
, self ? if isOverlayLib then lib else { }
, before ? if !isOverlayLib then lib else { }
, isOverlayLib ? false
}@args:
let
  colorHelpers = import ./color-helpers.nix { inherit lib; };
  lib = before // katlib // self;
  katlib = with before; with katlib; with self;
    {
      inherit (colorHelpers) hextorgba;
      nodeImport = import ./node-import.nix { inherit lib; };
      virtualHostGen = import ./virtual-host-gen.nix { inherit lib; };
      domainMerge = import ./domain-merge.nix { inherit lib; };
      modListMerge = import ./intersect-merge.nix { inherit lib; };
      modList = import ./module-list.nix { inherit lib; };
      folderList = import ./folder-list.nix { inherit lib; };
    };
in
katlib
