_: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      # layout
      layout = "bsp";
      window_origin_display = "focused";
      split_ratio = "0.50";
      mouse_modifier = "alt";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "stack";
      external_bar = "main:26:0";

      # window border
      window_border = "on";
      window_border_width = 3;
      window_border_hidpi = "on";

      # focus
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "off";

      # window
      window_placement = "second_child";
      window_border_blur = "on";

      # paddings
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
    };

    extraConfig = ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m rule --add app='Yubico Authenticator' manage=off
      yabai -m rule --add app='YubiKey Manager' manage=off
      yabai -m rule --add app='YubiKey Personalization Tool' manage=off

      # signals
      yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
      yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
      yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"
    '';
  };
}
