{
  system,
  inputs,
  ...
}@args: let
  lib = inputs.nixpkgs.lib;
  exportFile = import ./exports.nix args;
  inherit (exportFile) exports exportsSystems;
  inherit (inputs.std.lib) string list set;
  packages = inputs.self.packages.${system};
  inherit (inputs.self.legacyPackages.${system}) pkgs;
  nf-actions-test = pkgs.writeShellScriptBin "nf-actions-test" ''
      ${exports}
      ${exportsSystems}
      source ${./actions-test.sh}
  '';
in nf-actions-test
