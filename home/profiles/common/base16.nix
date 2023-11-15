{lib, ...}: let
  inherit (lib.modules) mkMerge;
in {
  base16 = {
    vim.enable = false;
    shell.enable = true;
    schemes = mkMerge [
      {
        light = "atelier.atelier-cave-light";
        dark = "atelier.atelier-cave";
      }
      {
        dark.ansi.palette.background.alpha = "ee00";
        light.ansi.palette.background.alpha = "d000";
      }
    ];
    defaultSchemeName = "light";
  };
}
