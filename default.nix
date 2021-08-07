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
    * A <argGenName> can exist at config/<argGenName>.
    * A <argGenName> can exist at config/trusted/<argGenName>.
  If only one exists, the path for that one is returned.
  Otherwise a module is generated which contains both import paths.
  */
  argGenNames = [ "profiles" "users" "targets" "services" ];
  argGen = lib.mapListToAttrs (folder: lib.nameValuePair folder (lib.domainMerge { inherit folder; })) argGenNames;

  /*
  This produces an attrSet of hosts based upon:
    * hosts being located within config/hosts/<hostname>/
  */
  hosts = lib.domainMerge {
    folder = "hosts";
    defaultFile = "meta.nix";
  };

  /*
  We use this to make the meta runner use this file and to use `--show-trace` on nix-builds.
  We also pass through pkgs to meta this way.
  */
  metaConfig = import ./meta-base.nix {
    inherit pkgs lib;
  };

  # This is where the meta config is evaluated.
  eval = lib.evalModules {
    modules = [
      metaConfig
      argGen.targets.personal
      argGen.targets.infra
      hosts.dummy
      hosts.athame
      hosts.beltane
      hosts.samhain
      hosts.yule
      ./config/modules/meta/default.nix
    ] ++ (lib.optional (builtins.pathExists ./config/trusted/meta.nix) ./config/trusted/meta.nix);
    specialArgs = {
      inherit sources;
      inherit (argGen) profiles users services;
    };
  };

  # The evaluated meta config.
  inherit (eval) config;

/*
  Please note all specialArg generated specifications use the folder common to both import paths.
  Those import paths are as mentioned above next to `argGenNames`.

  This provides us with a ./. that contains (most relevantly):
    * deploy.targets -> a mapping of target name to host names
    * network.nodes -> host names to host NixOS + home-manager configs
    * profiles -> the specialArg generated from profiles/
    * users -> the specialArg generated from users/
    * targets -> the specialArg generated from targets/
      * do not use common, it is tf-nix specific config ingested at line 66 of config/modules/meta/deploy.nix for every target.
    * services -> the specialArg generated from services/
*/
in config // { inherit pkgs hosts sourceCache sources; } // argGen
