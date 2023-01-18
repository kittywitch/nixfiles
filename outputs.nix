{ inputs }: let
  inherit (inputs.nixpkgs) lib;
  std = import ./std.nix {inherit inputs;};
  tree = import ./tree.nix {inherit inputs;};
  systems = import ./systems {inherit inputs tree lib std;};
  shells = import ./shells {inherit inputs tree lib std;};
in
  {inherit inputs tree lib std;} // systems // shells
