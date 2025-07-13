{inputs}: let
  std = import ./std.nix {inherit inputs;};
  tree = import ./tree.nix {inherit inputs pkgs;};
  inherit (inputs.nixpkgs) lib;
  overlay = import ./packages {inherit inputs tree;};
  systems = import ./systems {inherit inputs tree lib std pkgs;};
  shells = import ./shells {inherit inputs tree lib std pkgs;};
  inherit (import ./pkgs.nix {inherit inputs tree overlay;}) pkgs;
  formatting = import ./formatting.nix {inherit inputs pkgs;};
  wrappers = import ./wrappers {inherit inputs;};
  inherit (std) set;
  checks = set.map (_: deployLib: deployLib.deployChecks inputs.self.deploy) inputs.deploy-rs.lib;
in
  {
    inherit inputs tree std pkgs lib;
    legacyPackages = pkgs;
    #packages = set.merge [pkgs wrappers.packages];
    checks = checks // formatting.checks;
    inherit (formatting) formatter;
  }
  // systems
  // shells
