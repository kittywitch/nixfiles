{
  system,
  inputs,
  ...
} @ args: let
  inherit (inputs.nixpkgs) lib;
  exportFile = import ./exports.nix args;
  inherit (exportFile) exports;
  inherit (lib.strings) makeBinPath;
  inherit (inputs.std.lib.Std.compat) string;
  inherit (inputs.self.legacyPackages.${system}) pkgs;
  inherit (import ../ci/nix.nix) ci;
  nf-generate = pkgs.writeShellScriptBin "nf-generate" ''
    ${exports}
    export PATH="$PATH:${makeBinPath [pkgs.jq]}"
    NF_INPUT_CI=${string.escapeShellArg inputs.ci}
    NF_CONFIG_FILES=(${string.concatMapSep " " string.escapeShellArg ci.workflowConfigs})
    source ${./generate.sh}
  '';
in
  nf-generate
