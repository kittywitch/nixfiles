{
  system,
  inputs,
  ...
}@args: let
  lib = inputs.nixpkgs.lib;
  exportFile = import ./exports.nix args;
  inherit (exportFile) exports exportsSystems;
  inherit (lib.strings) makeBinPath;
  inherit (inputs.std.lib) string list set;
  packages = inputs.self.packages.${system};
  inherit (inputs.self.legacyPackages.${system}) pkgs;
    nf-generate = pkgs.writeShellScriptBin "nf-generate" ''
      ${exports}
      export PATH="$PATH:${makeBinPath [pkgs.jq]}"
      NF_INPUT_CI=${string.escapeShellArg inputs.ci}
      NF_CONFIG_FILES=(${string.concatMapSep " " string.escapeShellArg ci.workflowConfigs})
      source ${../ci/generate.sh}
    '';
in nf-generate