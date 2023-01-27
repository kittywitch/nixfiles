{inputs}: let
  inherit (inputs.nixpkgs) lib;
  std = import ./std.nix {inherit inputs;};
  tree = import ./tree.nix {inherit inputs;};
  systems = import ./systems {inherit inputs tree lib std;};
  shells = import ./shells {inherit inputs tree lib std pkgs;};
  inherit (import ./pkgs.nix {inherit inputs tree lib;}) pkgs;
  formatter = import ./formatter.nix {inherit inputs pkgs;};
  inherit (std) set;
  checks = set.map (_: deployLib: deployLib.deployChecks inputs.self.deploy) inputs.deploy-rs.lib;
in
  {inherit inputs tree lib std pkgs checks formatter;} // systems // shells
