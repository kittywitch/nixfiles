_: {
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "match:initial_class AlacrittyFloating, float on"
    ];
    windowrulev2 = [
      "suppressevent fullscreen, class:steam_app_default, content game"
      "suppressevent maximize, class:.*"

      "tile, class:battle\.net\.exe"

      "renderunfocused, class:discord, initialTitle:Discord"

      "unset, title:Wine System Tray"
      "workspace special:hidden silent, title:Wine System Tray"
      "noinitialfocus, title:Wine System Tray"

    ];
  };
}
