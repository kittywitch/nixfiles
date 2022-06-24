{ inputs, system, ... }: let
  optionalAttrs = cond: as: if cond then as else { };

  pkgs = import ./overlays { inherit inputs system; };
  darwin-pkgs = import ./overlays/darwin.nix { inherit inputs system; };
  inherit (pkgs) lib;

  mkTree = import ./tree.nix { inherit lib; };
  localTree = mkTree {
    inherit inputs;
    folder = ./config;
    config = {
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
      "modules/meta".functor.enable = true;
      "profiles/*".functor.enable = true;
      "profiles/hardware".evaluateDefault = true;
      "profiles/cross".evaluateDefault = true;
      "profiles/hardware/*".evaluateDefault = true;
      "services/*".aliasDefault = true;
      "users/*".evaluateDefault = true;
      "users/kat/*".functor.enable = true;
      "users/kat/services/mpd".functor.enable = true;
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

  xarg = tree.impure;

  eval = lib.evalModules {
    modules = lib.singleton metaBase
      ++ lib.singleton xarg.modules.meta
      ++ lib.attrValues xarg.targets
      ++ (map
      (host: {
        network.nodes.${host} = {
          imports = config.lib.kw.nodeImport host;
          networking = {
            hostName = host;
          };
        };
      })
      (lib.remove "sumireko" (lib.attrNames xarg.hosts)));

    specialArgs = {
      inherit inputs root tree;
      meta = self;
    } // xarg;
  };

  inherit (eval) config;


  self = config // { inherit pkgs lib inputs tree darwin-pkgs; } // xarg;
in
self
