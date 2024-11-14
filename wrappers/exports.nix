{inputs, ...}: let
  inherit (inputs.std.lib) string set;
  inherit (inputs.self) systems;
  enabledNixosSystems = set.filter (_: system: system.config.ci.enable && system.config.type == "NixOS") systems;
in {
  exports = ''
    export NF_CONFIG_ROOT=''${NF_CONFIG_ROOT-${toString ../.}}
    export CI_CONFIG_ROOT=$NF_CONFIG_ROOT
  '';
  exportsSystems = let
    warnSystems = set.filter (_: system: system.config.ci.allowFailure) enabledNixosSystems;
    toSystems = systems: string.concatMapSep " " string.escapeShellArg (set.keys systems);
  in ''
    NF_NIX_SYSTEMS=(${toSystems enabledNixosSystems})
    NF_NIX_SYSTEMS_WARN=(${toSystems warnSystems})
  '';
}
