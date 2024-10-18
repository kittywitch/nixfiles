{
  writeShellScriptBin,
  pkgs,
  inputs
  makeBinPath
}: let
  inherit (inputs.std) string list set;
  exports = ''
    export NF_CONFIG_ROOT=''${NF_CONFIG_ROOT-${toString ../.}}
  '';
  exportsSystems = let
    inherit (inputs.self) systems;
    nixosSystems = set.filter (_: system: system.ci.enable) systems;
    warnSystems = set.filter (_: system: system.ci.allowFailure) nixosSystems;
    toSystems = systems: string.concatMapSep " " string.escapeShellArg (set.keys systems);
  in ''
    NF_NIX_SYSTEMS=(${toSystems nixosSystems})
    NF_NIX_SYSTEMS_WARN=(${toSystems warnSystems})
  '';
in pkgs.writeShellScriptBin "nf-actions-test" ''
  ${exports}
  ${exportsSystems}
  source ${./actions-test.sh}
''
