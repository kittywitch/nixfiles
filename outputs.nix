{ inputs, system ? builtins.currentSystem or "x86_64-linux" , ... }: let
  optionalAttrs = cond: as: if cond then as else { };

  pkgs = import ./overlays { inherit inputs system; };
  inherit (pkgs) lib;

  mkTree = import ./tree.nix { inherit lib; };
  localTree = mkTree {
    inherit inputs;
    folder = ./.;
    config = {
      "/" = {
        excludes = [
          "tf"
          "inputs"
          "tree"
          "flake"
          "meta"
          "outputs"
          "inputs"
          "trusted"
        ];
      };
      "modules/nixos" = {
        functor = {
          enable = true;
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
      yggdrasil
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
          enable = true;
          external = [
            (import (inputs.arcexprs + "/modules")).home-manager
            (inputs.tf-nix + "/modules/home/secrets.nix")
          ];
        };
      };
      "modules/darwin".functor.enable = true;
      "modules/meta".functor.enable = true;
      "nixos/systems".functor.enable = false;
      "darwin/systems".functor.enable = false;
      "nixos/*".functor = {
        enable = true;
      };
      "darwin/*".functor = {
        enable = true;
      };
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

  root = ./.;

  metaBase = import ./meta.nix { inherit config lib pkgs root; };

  nixfiles = tree.impure;

  eval = let
    nixosNodes = (map
      (node: {
        network.nodes.nixos.${node} = {
          imports = config.lib.kw.nixosImport node;
          networking = {
            hostName = node;
          };
        };
      })
      (lib.attrNames nixfiles.nixos.systems));
    darwinNodes = (map
      (node: {
        network.nodes.darwin.${node} = {
          imports = config.lib.kw.darwinImport node;
          networking = {
            hostName = node;
          };
        };
      })
      (lib.attrNames nixfiles.darwin.systems));
  in lib.evalModules {
    modules = lib.singleton metaBase
      ++ lib.singleton nixfiles.modules.meta
      ++ lib.attrValues nixfiles.targets
      ++ nixosNodes
      ++ darwinNodes;

    specialArgs = {
      inherit inputs root tree;
      meta = self;
    } // nixfiles;
  };

  inherit (eval) config;


  self = config // { inherit pkgs lib inputs tree; } // nixfiles;
in
self
