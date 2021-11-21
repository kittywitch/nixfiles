import ./devShell.nix { inputs = import ./inputs.nix; system = builtins.currentSystem; }
