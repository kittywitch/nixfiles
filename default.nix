rec {
  sources = import ./nix/sources.nix;
  pkgs = import ./pkgs { inherit sources; };
  witch = import ./lib/witch.nix {
    inherit pkgs;
    lib = pkgs.lib;
  };
  profiles = witch.modList {
    modulesDir = ./profiles;
    defaultFile = "nixos.nix";
  };

  users = witch.modList { modulesDir = ./users; };

  inherit (import ./lib/hosts.nix {
    inherit pkgs sources witch profiles users;
    inherit (deploy) target;
  })
    hosts targets;

  inherit (pkgs) lib;

  deploy = import ./lib/deploy.nix {
    inherit pkgs sources;
    inherit hosts targets;
  };
}
