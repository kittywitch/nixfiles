rec {
  sources = import ./nix/sources.nix;
  pkgs = import ./pkgs { };
  witch = import ./lib/witch.nix { lib = pkgs.lib; };

  hosts = import ./lib/hosts.nix { inherit pkgs sources witch; };

  inherit (pkgs) lib;
  
  deploy = import ./lib/deploy.nix {
    inherit pkgs;
    inherit (hosts) hosts profiles;
  };
}
