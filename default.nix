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

  root = ./.;
  xarg = lib.recursiveMod { folder = ./config; inherit sources lib; };

  metaBase = import ./meta.nix { inherit config lib pkgs root; };

  eval = lib.evalModules {
    modules = lib.singleton metaBase
      ++ lib.singleton xarg.modules.meta
      ++ lib.attrValues (removeAttrs xarg.targets [ "common" ])
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
      inherit sources root;
      meta = self;
    } // xarg;
  };

  inherit (eval) config;

  self = config // { inherit pkgs lib sourceCache sources; } // xarg;
in
self
