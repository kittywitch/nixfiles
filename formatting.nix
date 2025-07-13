{inputs, ...}:
inputs.flake-utils.lib.eachDefaultSystem (system: let
  treefmtEval = inputs.treefmt-nix.lib.evalModule inputs.nixpkgs.legacyPackages.${system} ./treefmt.nix;
in {
  formatter = treefmtEval.config.build.wrapper;
  checks = {
    formatting = treefmtEval.config.build.check inputs.self;
  };
})
