{inputs}: let
  std = import ./std.nix {inherit inputs;};
  tree = import ./tree.nix {inherit inputs pkgs;};
  inherit (inputs.nixpkgs) lib;
  overlay = import ./packages {inherit inputs tree;};
  systems = import ./systems {inherit inputs tree lib std pkgs;};
  shells = import ./shells {inherit inputs tree lib std pkgs checks;};
  inherit (import ./pkgs.nix {inherit inputs tree overlay;}) pkgs;
  colmena = import ./colmena.nix {inherit inputs systems lib;};
  formatting = import ./formatting.nix {inherit inputs pkgs;};
  inherit (std) set;
  forAllSystems = lib.genAttrs inputs.flake-utils.lib.defaultSystems;
  checks = let
    git-hooks = system:
      inputs.git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          treefmt = {
            enable = true;
            packageOverrides = {treefmt = formatting.formatter.${system};};
          };
          # TODO: remove when cmake 4 changes aren't FUCKED
          #flake-checker.enable = true;
          ripsecrets.enable = true;
          pre-commit-hook-ensure-sops.enable = true;
        };
      };
    format = formatting.checks;
    deploy = set.map (_: deployLib: deployLib.deployChecks inputs.self.deploy) inputs.deploy-rs.lib;
  in
    forAllSystems (system: {
      deploy = deploy.${system};
      format = format.${system};
      git-hooks = git-hooks system;
    });
in
  {
    inherit inputs tree std pkgs lib checks;
    legacyPackages = pkgs;
    #packages = set.merge [pkgs wrappers.packages];
    inherit (formatting) formatter;
    inherit (colmena) colmenaHive colmena;
  }
  // systems
  // shells
