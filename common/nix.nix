{
  config,
  lib,
  std,
  inputs,
  ...
}: let
  inherit (std) set tuple list function;
  inherit (lib.strings) versionAtLeast;
  inputs' = set.filter (n: _: !list.elem n ["pypi-deps-db"]) (set.rename "self" "kat" inputs);
in {
  nix = {
    nixPath = set.mapToValues (name: flake: "${name}=${flake.outPath}") inputs';
    registry = set.map (_: flake: {inherit flake;}) inputs';

    settings = {
      experimental-features = list.optional (versionAtLeast config.nix.package.version "2.4") "nix-command flakes";
      substituters = ["https://arc.cachix.org" "https://kittywitch.cachix.org" "https://nix-community.cachix.org"];
      trusted-public-keys = ["arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
    };
  };
}
