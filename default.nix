rec {
  sources = import ./nix/sources.nix;
  pkgs = import ./pkgs { inherit sources; };
  modList = import ./lib/modules.nix;

  profiles = modList {
    modulesDir = ./profiles;
  };

  users = modList { modulesDir = ./users; };

  inherit (import ./lib/hosts.nix {
    inherit pkgs sources profiles users;
    inherit (deploy) target;
  }) hosts targets;

  inherit (pkgs) lib;

  runners = import ./runners.nix { inherit lib; inherit (deploy) target; };

  sourceCache = with lib; let
    getSources = sources: removeAttrs sources [ "__functor" "dorkfiles" ];
    source2drv = value: if isDerivation value.outPath then value.outPath else value;
    sources2drvs = sources: mapAttrs (_: source2drv) (getSources sources);
  in recurseIntoAttrs rec {
    local = sources2drvs sources;
    hexchen = sources2drvs (import sources.hexchen {}).sources;
    all = attrValues local ++ attrValues hexchen;
    allStr = toString all;
  };

  deploy = import ./lib/deploy.nix {
    inherit pkgs sources;
    inherit hosts targets;
  };
}
