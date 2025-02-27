{pkgs, ...}: {
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    #XDG_BACKEND = "x11";
    XDG_CURRENT_DESKTOP = "kde";
    #GDK_BACKEND = "x11";
  };
  home.packages = with pkgs.kdePackages; [
    kscreen
    kwin
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
    pkgs.plasma-applet-commandoutput

    # Application integration
    libplasma # provides Kirigami platform theme
    plasma-integration # provides Qt platform theme
    kde-gtk-config # syncs KDE settings to GTK

    qt6ct
    pkgs.libsForQt5.qt5ct

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
    enable = true;
    workspace = {
    };
    fonts = let
      katFont = {
        family = "Monaspace Krypton";
        pointSize = 10;
      };
    in {
      general = katFont;
      fixedWidth = katFont;
      small = katFont // {pointSize = 8;};
      toolbar = katFont;
      menu = katFont;
      windowTitle = katFont;
    };
    configFile = {
      "kdeglobals"."General"."BrowserApplication" = "firefox.desktop";
      "kdeglobals"."General"."TerminalApplication" = "konsole";
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "kxkbrc"."Layout"."Options" = "terminate:ctrl_alt_bksp,ctrl:capscontrol";
    };
  };
}
