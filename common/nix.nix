{
  config,
  lib,
  std,
  inputs,
  tree,
  ...
}: let
  inherit (std) set tuple list;
  inherit (lib.strings) versionAtLeast;
  renameAttrs = names: set.remap ({_0, _1}: tuple.tuple2 (names.${_0} or _0) _1);
  renameAttr = oldName: newName: renameAttrs { ${oldName} = newName; };
in {
  nix = {
    nixPath = set.mapToValues (name: flake: "${name}=${flake.outPath}") (renameAttr "self" "kat" inputs);
    registry = set.map (_: flake: {inherit flake;}) inputs;

    settings = {
      experimental-features = list.optional (versionAtLeast config.nix.package.version "2.4") "nix-command flakes";
      substituters = ["https://arc.cachix.org" "https://kittywitch.cachix.org" "https://nix-community.cachix.org"];
      trusted-public-keys = ["arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
    };
  };
}
