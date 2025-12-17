_: {
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "suppressevent fullscreen, class:steam_app_default"
    "workspace 2, class:steam_app_default"
    "suppressevent maximize, class:.*"

    "tile, class:battle\.net\.exe"

    "renderunfocused, class:discord, initialTitle:Discord"

    "unset, title:Wine System Tray"
    "workspace special:hidden silent, title:Wine System Tray"
    "noinitialfocus, title:Wine System Tray"

    "float, class:^(AlacrittyFloating)$"
  ];
}
