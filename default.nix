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
      ./config/targets
      ./config/modules/meta/default.nix
    ] ++ map (hostName: ./config/hosts + "/${hostName}/meta.nix") hostNames;
    specialArgs = {
      inherit sources profiles users;
    };
  };
  inherit (eval) config;
in config // { inherit pkgs sourceCache sources; }
