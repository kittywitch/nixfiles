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
      focus_follows_mouse = "off";
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
      # spaces
      function setup_space {
        local idx="$1"
        local name="$2"
        local space=
        echo "setup space $idx : $name"
        space=$(yabai -m query --spaces --space "$idx")
        if [ -z "$space" ]; then
          yabai -m space --create
        fi
        yabai -m space "$idx" --label "$name"
      }

      setup_space 1 work
      setup_space 2 chat
      setup_space 3 www
      setup_space 4 code
      setup_space 5 term
      setup_space 6 music
      setup_space 7 brain
      setup_space 8 office
      setup_space 9 email
      setup_space 10 misc

      # rules
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m rule --add app='Yubico Authenticator' manage=off
      yabai -m rule --add app='YubiKey Manager' manage=off
      yabai -m rule --add app='YubiKey Personalization Tool' manage=off
      yabai -m rule --add app="^Slack$" space=1
      yabai -m rule --add app="^Microsoft Teams$" space=1
      yabai -m rule --add app="^Discord$" space=2
      yabai -m rule --add app="^Element$" space=2
      yabai -m rule --add app="^Telegram Desktop$" space=2
      yabai -m rule --add app="^Brave Browser$" space=^3
      yabai -m rule --add app="^Orion$" space=^3
      yabai -m rule --add app="^VSCodium$" space=^4
      yabai -m rule --add app="^Spotify$" space=6
      yabai -m rule --add app="^Obsidian$" space=7
      yabai -m rule --add app="^Microsoft Word$" space=8
      yabai -m rule --add app="^Microsoft Powerpoint$" space=8
      yabai -m rule --add app="^Microsoft Excel$" space=8
      yabai -m rule --add app="^Microsoft Outlook$" space=9
      yabai -m rule --add app="^Calendar$" space=9
      yabai -m rule --add app="^Mail$" space=9


      # signals
      yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
      yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
      yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"
    '';
  };
}
