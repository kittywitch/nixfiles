# Taken from: https://git.gay/olivia/fur/src/branch/main/modules/home/palette/default.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  palette =
    (pkgs.lib.importJSON (config.catppuccin.sources.palette + "/palette.json"))
    .${config.catppuccin.flavor}.colors;
in
{
  options.palette = mkOption { type = types.attrsOf types.raw; };
  config = {
    inherit palette;
  };
}


