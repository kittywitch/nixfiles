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
  # This is used for the base path for nodeImport.
  root = ./.;

  /*
    This is used to generate specialArgs + the like. It works as such:
    * A <xargName> can exist at config/<subconfigName>.
    * A <xargName> can exist at config/trusted/<subconfigName>.
    If only one exists, the path for that one is returned.
    Otherwise a module is generated which contains both import paths.
  */
  xargNames = lib.unique (lib.folderList ./config [ "trusted" ] ++ lib.folderList ./config/trusted [ "pkgs" "tf" ]);
  xarg = lib.mapListToAttrs
    (folder: lib.nameValuePair folder (lib.domainMerge {
      inherit folder;
      folderPaths = [ (./config + "/${folder}") (./config/trusted + "/${folder}") ];
    }))
    xargNames;

  /*
    We provide the runners with this file this way. We also provide our nix args here.
    This is also where pkgs are passed through to the meta config.
  */
  metaConfig = {
    config = {
      runners = {
        lazy = {
          file = root;
          args = [ "--show-trace" ];
        };
      };
      _module.args = {
        pkgs = lib.mkDefault pkgs;
      };

      deploy.targets.dummy.enable = false;
    };
  };

  # This is where the meta config is evaluated.
  eval = lib.evalModules {
    modules = lib.singleton metaConfig
      ++ lib.attrValues (removeAttrs xarg.targets [ "common" ])
      ++ (map
      (host: {
        network.nodes.${host} = {
          imports = config.lib.kw.nodeImport host;
        };
      })
      (lib.attrNames xarg.hosts))
      ++ lib.singleton ./config/modules/meta/default.nix;

    specialArgs = {
      inherit sources root;
      meta = self;
    } // xarg;
  };

  # The evaluated meta config.
  inherit (eval) config;

  /*
    Please note all specialArg generated specifications use the folder common to both import paths.
    Those import paths are as mentioned above next to `xargNames`.

    This provides us with a ./. that contains (most relevantly):
    * deploy.targets -> a mapping of target name to host names
    * network.nodes -> host names to host NixOS + home-manager configs
    * profiles -> the specialArg generated from profiles/
    * users -> the specialArg generated from users/
    * targets -> the specialArg generated from targets/
    * do not use common, it is tf-nix specific config ingested at line 66 of config/modules/meta/deploy.nix for every target.
    * services -> the specialArg generated from services/
  */
  self = config // { inherit pkgs lib sourceCache sources; } // xarg;
in
self
