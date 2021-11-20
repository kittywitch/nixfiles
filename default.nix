let
  # we don't have lib without sources, so we need optionalAttrs
  optionalAttrs = cond: as: if cond then as else { };
  # Sources are from niv.
  sources = import ./nix/sources.nix // optionalAttrs (builtins.pathExists ./overlays/exprs/default.nix) {
    katexprs = ./overlays/exprs;
  };

  # We pass sources through to pkgs and get our nixpkgs + overlays.
  pkgs = import ./overlays { inherit sources; };
  # We want our overlaid lib.
  inherit (pkgs) lib;
  # This is used for caching niv sources in CI.
  sourceCache = with lib; let
    getSources = sources: removeAttrs sources [ "__functor" "dorkfiles" ];
    source2drv = value: if isDerivation value.outPath then value.outPath else value;
    sources2drvs = sources: mapAttrs (_: source2drv) (getSources sources);
  in
  recurseIntoAttrs rec {
    local = sources2drvs sources;
    hexchen = sources2drvs (import sources.hexchen { }).sources;
    all = attrValues local ++ attrValues hexchen;
    allStr = toString all;
  };

  tree = import ./tree.nix { inherit lib; } {
    inherit sources;
    folder = ./config;
    config = {
      "modules/nixos" = {
        functor = {
          enable = true;
          external = [
            (import (sources.arcexprs + "/modules")).nixos
            (import (sources.katexprs + "/modules")).nixos
            (import (sources.impermanence + "/nixos.nix"))
            (import sources.anicca).modules.nixos
            (sources.tf-nix + "/modules/nixos/secrets.nix")
            (sources.tf-nix + "/modules/nixos/secrets-users.nix")
          ];
        };
      };
      "modules/home" = {
        functor = {
          enable = true;
          external = [
            (import (sources.arcexprs + "/modules")).home-manager
            (import (sources.katexprs + "/modules")).home
            (import (sources.impermanence + "/home-manager.nix"))
            (import sources.anicca).modules.home
            (sources.tf-nix + "/modules/home/secrets.nix")
          ];
        };
      };
      "modules/meta".functor.enable = true;
      "profiles/*".functor.enable = true;
      "profiles/hardware".evaluateDefault = true;
      "profiles/cross".evaluateDefault = true;
      "profiles/hardware/*".evaluateDefault = true;
      "services/*".aliasDefault = true;
      "trusted/secrets".evaluateDefault = true;
      "trusted".excludes = [ "tf" ];
      "users/*".evaluateDefault = true;
      "users/kat/*".functor.enable = true;
      "users/kat/services/mpd".functor.enable = true;
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
      (lib.attrNames xarg.hosts));

    specialArgs = {
      inherit sources root tree;
      meta = self;
    } // xarg;
  };

  inherit (eval) config;


  self = config // { inherit pkgs lib sourceCache sources tree; } // xarg;
in
self
