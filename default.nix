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

  hosts = import ./lib/hosts.nix {
    inherit pkgs sources witch profiles;
    inherit (deploy) target;
  };

  inherit (pkgs) lib;

  deploy = import ./lib/deploy.nix {
    inherit pkgs sources;
    inherit (hosts) hosts targets;
  };
}
