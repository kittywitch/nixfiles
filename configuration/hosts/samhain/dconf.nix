# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  dconf.settings = {
    "org/gnome/control-center" = {
      "last-panel" = "network";
    };

    "org/gnome/desktop/input-sources" = {
      "current" = "uint32 0";
      "sources" = [ (mkTuple [ "xkb" "gb" ]) ];
      "xkb-options" = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/interface" = {
      "clock-show-seconds" = true;
      "clock-show-weekday" = true;
      "enable-hot-corners" = false;
      "gtk-im-module" = "gtk-im-context-simple";
    };

    "org/gnome/desktop/notifications" = {
      "application-children" = [ "im-dino-dino" "telegramdesktop" "discord" "mumble" "firefox" ];
    };

    "org/gnome/desktop/notifications/application/discord" = {
      "application-id" = "discord.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      "application-id" = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/im-dino-dino" = {
      "application-id" = "im.dino.Dino.desktop";
    };

    "org/gnome/desktop/notifications/application/mumble" = {
      "application-id" = "mumble.desktop";
    };

    "org/gnome/desktop/notifications/application/telegramdesktop" = {
      "application-id" = "telegramdesktop.desktop";
    };

    "org/gnome/desktop/privacy" = {
      "report-technical-problems" = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      "panel-main-menu" = [ "<Alt>F1" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      "button-layout" = "appmenu:minimize,maximize,close";
    };

    "org/gnome/evolution-data-server" = {
      "migrated" = true;
      "network-monitor-gio-name" = "";
    };

    "org/gnome/mutter" = {
      "attach-modal-dialogs" = true;
      "dynamic-workspaces" = true;
      "edge-tiling" = true;
      "focus-change-on-pointer-rest" = true;
      "overlay-key" = "Super_L";
      "workspaces-only-on-primary" = true;
    };

    "org/gnome/nautilus/preferences" = {
      "default-folder-viewer" = "icon-view";
      "search-filter-time-type" = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      "initial-size" = mkTuple [ 890 550 ];
      "maximized" = false;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      #"night-light-last-coordinates" = mkTuple [ 51.579800719942405 -2.47e-2 ];
    };

    "org/gnome/settings-daemon/plugins/xsettings" = {
      "antialiasing" = "grayscale";
      "hinting" = "slight";
    };

    "org/gnome/shell" = {
      "disabled-extensions" = "@as []";
      "enabled-extensions" = [ "arc-menu@linxgem33.com" "caffeine@patapon.info" "dash-to-panel@jderose9.github.com" "emoji-selector@maestroschan.fr" "appindicatorsupport@rgcjonas.gmail.com" ];
    };

    "org/gnome/shell/extensions/arc-menu" = {
      "arc-menu-icon" = 3;
      "dtp-dtd-state" = [ true false ];
      "menu-button-icon" = "Arc_Menu_Icon";
      "menu-hotkey" = "Super_L";
      "pinned-app-list" = [ "Firefox" "firefox" "firefox.desktop" "Terminal" "utilities-terminal" "org.gnome.Terminal.desktop" "Arc Menu Settings" "ArcMenu_ArcMenuIcon" "gnome-extensions prefs arc-menu@linxgem33.com" ];
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      "available-monitors" = [ 1 0 2 ];
      "group-apps" = false;
      "hotkeys-overlay-combo" = "TEMPORARILY";
      "multi-monitors" = false;
      #"panel-element-positions" = "'{"0":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}],"1":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}],"2":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'";
      #"panel-positions" = "'{"0":"TOP","1":"TOP","2":"TOP"}'";
      "panel-size" = 32;
      "primary-monitor" = 1;
    };

    "org/gnome/shell/world-clocks" = {
      "locations" = "@av []";
    };

    "org/gnome/system/location" = {
      "enabled" = true;
    };

    "org/gtk/settings/file-chooser" = {
      "date-format" = "regular";
      "location-mode" = "path-bar";
      "show-hidden" = false;
      "show-size-column" = true;
      "show-type-column" = true;
      "sidebar-width" = 164;
      "sort-column" = "name";
      "sort-directories-first" = false;
      "sort-order" = "ascending";
      "type-format" = "category";
      "window-position" = mkTuple [ 358 907 ];
      "window-size" = mkTuple [ 1203 902 ];
    };

  };
}
