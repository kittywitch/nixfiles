{
  inputs,
  lib,
  ...
}: let
  mkTree = import ./mkTree.nix {inherit lib;};
  tree = mkTree {
    inherit inputs;
    folder = ./.;
    config = {
      "/" = {
        excludes = [
          "tf"
          "inputs"
          "default"
          "patchedInputs"
          "mkTree"
          "outputs"
          "tree"
          "flake"
          "meta"
          "inputs"
        ];
      };
      "modules/nixos" = {
        functor = {
          external =
            (with (import (inputs.arcexprs + "/modules")).nixos; [
              nix
              systemd
              dht22-exporter
              glauth
              modprobe
              kernel
              crypttab
              mutable-state
              common-root
              pulseaudio
              wireplumber
              alsa
              bindings
              matrix-appservices
              matrix-synapse-appservices
              display
              filebin
              mosh
              base16
              base16-shared
              doc-warnings
            ]);
        };
      };
      "modules/home" = {
        functor = {
          external = [
            (import (inputs.arcexprs + "/modules")).home-manager
          ];
        };
      };
      "modules/nixos".functor.enable = true;
      "modules/meta".functor.enable = true;
      "modules/system".functor.enable = true;
      "modules/home".functor.enable = true;
      "modules/type".functor.enable = true;
      "nixos/systems".functor.enable = false;
      "nixos/*".functor = {
        enable = true;
      };
      "system".functor.enable = true;
      "hardware".evaluateDefault = true;
      "nixos/cross".evaluateDefault = true;
      "hardware/*".evaluateDefault = true;
      "home".evaluateDefault = true;
      "home/*".functor.enable = true;
    };
  };
in
  tree
