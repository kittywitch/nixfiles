inputs: let
  inherit (inputs.nixpkgs) lib;
  tree = import ./tree.nix {inherit inputs;};
  systems = import ./systems {inherit inputs tree lib;};
  shells = import ./shells {inherit inputs tree lib;};
in
  {inherit inputs tree lib;} // systems // shells
