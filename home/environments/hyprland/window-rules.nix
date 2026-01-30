_: {
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "match:initial_class AlacrittyFloating, float on"
      "match:initial_class battle\.net\.exe tile on workspace special:hidden silent"
      "match:initial_class discord renderunfocused"
      "match:initial_title \"Wine System Tray\" unset"
      "match:initial_class Unity no_follow_mouse on"
      "match:initial_class steam focusonactivate off suppressevent activate"
      "match:initial_class steam_app_default match:content 3 suppressevent fullscreen"
    ];
  };
}
