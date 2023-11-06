_: {
  programs.plasma = {
    configFile = {
     "kded5rc"."PlasmaBrowserIntegration"."shownCount" = 1;
     "kdeglobals"."WM"."activeBackground" = "231,232,235";
     "kdeglobals"."WM"."activeBlend" = "231,232,235";
     "kdeglobals"."WM"."activeForeground" = "92,97,108";
     "kdeglobals"."WM"."inactiveBackground" = "231,232,235";
     "kdeglobals"."WM"."inactiveBlend" = "231,232,235";
     "kdeglobals"."WM"."inactiveForeground" = "163,165,172";
     "kxkbrc"."Layout"."Options" = "terminate:ctrl_alt_bksp,ctrl:nocaps";
     "kxkbrc"."Layout"."ResetOldOptions" = true;
    };
  };
}
