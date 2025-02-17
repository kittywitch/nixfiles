{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs.base16-data.lib.base16-data) schemeSources;
in {
  base16 = {
    vim = {
      enable = false;
      template = inputs.base16-data.legacyPackages.${pkgs.system}.base16-templates.vim.withTemplateData;
    };
    shell.enable = true;
    schemes = {
      light = {
        schemeData = schemeSources.atelier.schemes.atelier-heath-light;
        ansi.palette.background.alpha = "d000";
      };
      dark = {
        schemeData = schemeSources.outrun.schemes.outrun-dark;
        ansi.palette.background.alpha = "ee00";
      };
    };
    defaultSchemeName = "dark";
  };
}
