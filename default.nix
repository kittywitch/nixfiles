let
  sources = import ./nix/sources.nix;
  pkgs = import ./pkgs { inherit sources; };
  inherit (pkgs) lib;
  sourceCache = import ./cache.nix {
    inherit sources lib;
  };
  profiles = lib.modList {
    modulesDir = ./config/profiles;
  };
  targets = lib.removeAttrs (lib.modList {
    modulesDir = ./config/targets;
  }) ["common"];
  users = lib.modList {
    modulesDir = ./config/users;
  };
  metaConfig = import ./meta-base.nix {
    inherit pkgs lib;
  };
  hostNames = [
    "dummy"
    "athame"
    "beltane"
    "samhain"
    "yule"
    # "mabon"
    # "ostara"
  ];
  eval = lib.evalModules {
    modules = [
      metaConfig
      targets.personal
      targets.infra
      ./config/modules/meta/default.nix
    ] ++ map (hostName: ./config/hosts + "/${hostName}/meta.nix") hostNames;
    specialArgs = {
      inherit sources profiles users;
    };
  };
  inherit (eval) config;
in config // { inherit pkgs sourceCache sources; }
