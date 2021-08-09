let
  # Sources are from niv.
  sources = import ./nix/sources.nix;
  # We pass sources through to pkgs and get our nixpkgs + overlays.
  pkgs = import ./pkgs { inherit sources; };
  # We want our overlaid lib.
  inherit (pkgs) lib;
  # This is used for caching niv sources in CI.
  sourceCache = import ./cache.nix { inherit sources lib; };

  /*
  This is used to generate specialArgs + the like. It works as such:
    * A <depotName> can exist at config/<depotName>.
    * A <depotName> can exist at config/trusted/<depotName>.
  If only one exists, the path for that one is returned.
  Otherwise a module is generated which contains both import paths.
  */
  filterAttrNamesToList = filter: set:
    lib.foldl' (a: b: a ++ b) [ ]
      (map (e: if (filter e set.${e}) then [ e ] else [ ]) (lib.attrNames set));
  depotNames = lib.unique ((lib.folderList ./depot ["trusted"]) ++ (lib.folderList ./depot/trusted ["pkgs"]));
  depot = lib.mapListToAttrs (folder: lib.nameValuePair folder (lib.domainMerge { inherit folder; })) depotNames;

  /*
  We use this to make the meta runner use this file and to use `--show-trace` on nix-builds.
  We also pass through pkgs to meta this way.
  */
  metaConfig = import ./meta-base.nix {
    inherit pkgs lib depot;
  };

  # This is where the meta config is evaluated.
  eval = lib.evalModules {
    modules = lib.singleton metaConfig
    ++ lib.attrValues (removeAttrs depot.targets ["common"])
    ++ lib.attrValues depot.hosts
    ++ lib.optional (builtins.pathExists ./depot/trusted/meta.nix) ./depot/trusted/meta.nix
    ++ lib.singleton ./depot/modules/meta/default.nix;

    specialArgs = {
      inherit sources;
      meta = self;
    } // depot;
  };

  # The evaluated meta config.
  inherit (eval) config;

/*
  Please note all specialArg generated specifications use the folder common to both import paths.
  Those import paths are as mentioned above next to `depotNames`.

  This provides us with a ./. that contains (most relevantly):
    * deploy.targets -> a mapping of target name to host names
    * network.nodes -> host names to host NixOS + home-manager configs
    * profiles -> the specialArg generated from profiles/
    * users -> the specialArg generated from users/
    * targets -> the specialArg generated from targets/
      * do not use common, it is tf-nix specific config ingested at line 66 of config/modules/meta/deploy.nix for every target.
    * services -> the specialArg generated from services/
*/
  self = config // { inherit pkgs lib sourceCache sources; } // depot;
in self
