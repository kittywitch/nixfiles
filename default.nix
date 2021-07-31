let
  sources = import ./nix/sources.nix;
  pkgs = import ./pkgs { inherit sources; };
  inherit (pkgs) lib;

  profiles = lib.modList {
    modulesDir = ./config/profiles;
  };

  users = lib.modList {
    modulesDir = ./config/users;
  };

  metaConfig = { ... }: {
    config = {
      runners = {
        lazy = {
          file = ./.;
          args = [ "--show-trace" ];
        };
      };
      _module.args = {
        pkgs = lib.mkDefault pkgs;
      };
    };
  };

  eval = lib.evalModules {
    modules = [
      metaConfig
      ./config/targets
      ./config/modules/meta/default.nix
      ./config/hosts/dummy/meta.nix
      ./config/hosts/athame/meta.nix
      ./config/hosts/beltane/meta.nix
      ./config/hosts/samhain/meta.nix
      ./config/hosts/yule/meta.nix
      ./config/hosts/mabon/meta.nix
      ./config/hosts/ostara/meta.nix
    ];
    specialArgs = {
      inherit sources profiles users;
    };
  };
  inherit (eval) config;


  sourceCache = with lib; let
    getSources = sources: removeAttrs sources [ "__functor" ]; #"dorkfiles" ];
    source2drv = value: if isDerivation value.outPath then value.outPath else value;
    sources2drvs = sources: mapAttrs (_: source2drv) (getSources sources);
  in recurseIntoAttrs rec {
    local = sources2drvs sources;
    #hexchen = sources2drvs (import sources.hexchen {}).sources;
    all = attrValues local; #++ attrValues hexchen;
    allStr = toString all;
  };
in config // { inherit pkgs sourceCache sources; }
