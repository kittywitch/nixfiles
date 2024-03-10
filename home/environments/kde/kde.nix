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
      "kdeglobals"."General"."BrowserApplication" = "firefox.desktop";
      "kdeglobals"."General"."TerminalApplication" = "wezterm start --cwd .";
      "kdeglobals"."General"."TerminalService" = "org.wezfurlong.wezterm.desktop";
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "plasmarc"."Theme"."name" = "Arc";
      "kxkbrc"."Layout"."Options" = "terminate:ctrl_alt_bksp,ctrl:hyper_capscontrol";
    };
  };
}
