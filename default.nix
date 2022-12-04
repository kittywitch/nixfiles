let
  inputs = import ./inputs.nix;
  self = import ./outputs.nix ({
    inherit self inputs;
    system = builtins.currentSystem;
  } // inputs);
in self
