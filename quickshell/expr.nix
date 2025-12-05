{hostname}: let
  nixfiles = import ../.;
  inherit (nixfiles) lib nixosConfigurations;
  palette' = nixosConfigurations.${hostname}.config.stylix.generated.palette;
  palette = lib.mapAttrs (k: v:
    if (lib.strings.hasPrefix "base" k)
    then "#${lib.strings.toUpper v}"
    else v)
  palette';
  paletteWithAliases = palette: {
    defaultBg = palette.base00;
    lighterBg = palette.base01;
    selectionBg = palette.base02;
    comments = palette.base03;
    darkFg = palette.base04;
    defaultFg = palette.base05;
    lightFg = palette.base06;
    lightBg = palette.base07;
    variable = palette.base08;
    integer = palette.base09;
    classy = palette.base0A;
    stringy = palette.base0B;
    support = palette.base0C;
    functiony = palette.base0D;
    keyword = palette.base0E;
    deprecated = palette.base0F;
  };
  fullPalette = palette // (paletteWithAliases palette);
in {
  expr = fullPalette;
}
