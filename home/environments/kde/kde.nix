{pkgs, ...}: {
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
  home.packages = with pkgs.kdePackages; [
    kscreen
    pkgs.xwayland
    kscreen
    libkscreen
    kscreenlocker
    kactivitymanagerd
    kde-cli-tools
    kglobalacceld # keyboard shortcut daemon
    kwrited # wall message proxy, not to be confused with kwrite
    baloo # system indexer
    milou # search engine atop baloo
    kdegraphics-thumbnailers # pdf etc thumbnailer
    polkit-kde-agent-1 # polkit auth ui
    plasma-desktop
    plasma-workspace
    drkonqi # crash handler
    kde-inotify-survey # warns the user on low inotifywatch limits

    # Application integration
    libplasma # provides Kirigami platform theme
    plasma-integration # provides Qt platform theme
    kde-gtk-config # syncs KDE settings to GTK

    # Artwork + themes
    breeze
    breeze-icons
    breeze-gtk
    ocean-sound-theme
    plasma-workspace-wallpapers
    pkgs.hicolor-icon-theme # fallback icons
    qqc2-breeze-style
    qqc2-desktop-style

    # misc Plasma extras
    kdeplasma-addons
    pkgs.xdg-user-dirs # recommended upstream

    # Plasma utilities
    kmenuedit
    kinfocenter
    plasma-systemmonitor
    ksystemstats
    libksysguard
    systemsettings
    kcmutils
  ];
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
      "kdeglobals"."General"."TerminalService" = "org.wezfurlong.wezterm.desktop";
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "kxkbrc"."Layout"."Options" = "terminate:ctrl_alt_bksp,ctrl:hyper_capscontrol";
    };
  };
}
