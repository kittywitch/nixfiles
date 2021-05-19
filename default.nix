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
  })
    hosts targets;

    inherit (pkgs) lib;

    runners = import ./runners.nix { inherit lib; inherit (deploy) target; };

    getSources = sources: lib.attrValues (lib.removeAttrs sources [ "__functor" ]);
    sourceCache = map(value: if lib.isDerivation value.outPath then value.outPath else value) (getSources sources ++ getSources (import sources.nix-hexchen {}).sources);

  deploy = import ./lib/deploy.nix {
    inherit pkgs sources;
    inherit hosts targets;
  };
}
