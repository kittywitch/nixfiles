{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib.attrsets) mapAttrs mapAttrsToList;
  inherit (lib.lists) optional;
  inherit (lib.strings) versionAtLeast;
in {
  nix = {
    nixPath = mapAttrsToList (name: flake: "${name}=${flake}") inputs;
    registry = mapAttrs (_: flake: {inherit flake;}) inputs;

    settings = {
      experimental-features = optional (versionAtLeast config.nix.package.version "2.4") "nix-command flakes";
      substituters = ["https://arc.cachix.org" "https://kittywitch.cachix.org" "https://nix-community.cachix.org"];
      trusted-public-keys = ["arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
    };
  };
}
