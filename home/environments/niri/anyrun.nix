{
  config,
  lib,
  ...
}: let
  cfg = config.programs.anyrun;
  inherit (lib.meta) getExe;
in {
  programs.niri.settings.binds = {
    "Mod+D".action = let
      sh = config.lib.niri.actions.spawn "sh" "-c";
    in
      sh (getExe cfg.package);
  };
  programs.anyrun = {
    enable = true;
    config = {
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      width = {fraction = 0.3;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = true;
      maxEntries = null;
      plugins = let
        pluginNames = [
          "applications"
          "symbols"
          "niri_focus"
          "dictionary"
          "rink"
          "nix_run"
        ];
        pluginLibs = map (p: "${cfg.package}/lib/lib${p}.so") pluginNames;
      in
        pluginLibs;
    };
  };
}
