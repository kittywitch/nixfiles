{ inputs, lib, ... }: let
  mkTree = import ./mkTree.nix { inherit lib; };
  localTree = mkTree {
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
          "trusted"
        ];
      };
      "modules/nixos" = {
        functor = {
          external = [
            (inputs.tf-nix + "/modules/nixos/secrets.nix")
            (inputs.tf-nix + "/modules/nixos/secrets-users.nix")
          ] ++ (with (import (inputs.arcexprs + "/modules")).nixos; [
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
            base16 base16-shared
            doc-warnings
          ]);
        };
      };
      "modules/home" = {
        functor = {
          external = [
            (import (inputs.arcexprs + "/modules")).home-manager
            (inputs.tf-nix + "/modules/home/secrets.nix")
          ];
        };
      };
      "modules/nixos".functor.enable = true;
      "modules/darwin".functor.enable = true;
      "modules/meta".functor.enable = true;
      "modules/tf".functor.enable = true;
      "modules/system".functor.enable = true;
      "modules/home".functor.enable = true;
      "modules/esphome".functor.enable = true;
      "modules/type".functor.enable = true;
      "nixos/systems".functor.enable = false;
      "darwin/systems".functor.enable = false;
      "nixos/*".functor = {
        enable = true;
      };
      "darwin/*".functor = {
        enable = true;
      };
      "system".functor.enable = true;
      "hardware".evaluateDefault = true;
      "nixos/cross".evaluateDefault = true;
      "hardware/*".evaluateDefault = true;
      "services/*".aliasDefault = true;
      "home".evaluateDefault = true;
      "home/*".functor.enable = true;
    };
  };
  trustedTree = mkTree {
    inherit inputs;
    folder = inputs.trusted;
    config = {
      "secrets".evaluateDefault = true;
    };
  };
  tree = localTree // {
    pure = localTree.pure // {
      trusted = trustedTree.pure;
    };
    impure = localTree.impure // {
      trusted = trustedTree.impure;
    };
  };
in tree
