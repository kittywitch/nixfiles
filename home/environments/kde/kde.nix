{pkgs, ...}: {
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
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
  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
    General.theme = "commonalitysol";
  };
  programs.plasma = {
    enable = true;
    workspace = {
      colorScheme = "CommonalitySol";
      theme = "CommonalitySol";
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
      "kded5rc"."PlasmaBrowserIntegration"."shownCount" = 1;
      "kdeglobals"."General"."BrowserApplication" = "firefox.desktop";
      "kdeglobals"."General"."TerminalApplication" = "konsole";
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "kxkbrc"."Layout"."Options" = "terminate:ctrl_alt_bksp,ctrl:hyper_capscontrol";
    };
  };
}
