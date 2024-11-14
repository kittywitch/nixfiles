{
  system,
  inputs,
  ...
} @ args: let
  exportFile = import ./exports.nix args;
  inherit (exportFile) exports exportsSystems;
  inherit (inputs.self.legacyPackages.${system}) pkgs;
  nf-actions-test = pkgs.writeShellScriptBin "nf-actions-test" ''
    ${exports}
    ${exportsSystems}
    source ${./actions-test.sh}
  '';
in
  nf-actions-test
