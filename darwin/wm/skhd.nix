{std, ...}: let
  inherit (std) string list;
in {
  services.skhd = {
    enable = true;
    skhdConfig = let
      bindWorkspace = key: workspace: ''
        alt - ${key} : yabai -m space --focus  ${workspace}
        shift + alt - ${key} : yabai -m window --space ${workspace}
      '';
      workspaceBindings = string.concat (list.map (v: bindWorkspace v "${v}") (list.map builtins.toString (list.range 1 9))
        ++ [
          (
            bindWorkspace "0" "10"
          )
        ]
        ++ list.imap (i: v: bindWorkspace v "${toString (10 + i + 1)}") (list.map (n: "f${builtins.toString n}") (std.list.range 1 12)));
    in
      workspaceBindings
      + ''
        # focus windows - ESDF
        alt - s : yabai -m window --focus west
        alt - d : yabai -m window --focus south
        alt - e : yabai -m window --focus north
        alt - f : yabai -m window --focus east

        # focus windows - arrows
        alt - left : yabai -m window --focus west
        alt - down : yabai -m window --focus south
        alt - up : yabai -m window --focus north
        alt - right : yabai -m window --focus east

        # move windows - ESDF
        shift + alt - s : yabai -m window --swap west
        shift + alt - d : yabai -m window --swap south
        shift + alt - e : yabai -m window --swap north
        shift + alt - f : yabai -m window --swap east

        # move windows - arrows
        shift + alt - left : yabai -m window --swap west
        shift + alt - down : yabai -m window --swap south
        shift + alt - up : yabai -m window --swap north
        shift + alt - right : yabai -m window --swap east

        # warp windows - ESDF
        ctrl + alt - s : yabai -m window --warp west
        ctrl + alt - d : yabai -m window --warp south
        ctrl + alt - e : yabai -m window --warp north
        ctrl + alt - f : yabai -m window --warp east

        # warp windows - arrows
        ctrl + alt - left : yabai -m window --warp west
        ctrl + alt - down : yabai -m window --warp south
        ctrl + alt - up : yabai -m window --warp north
        ctrl + alt - right : yabai -m window --warp east

        # process management - q
        # unused base -> spotlight exists (cmd+space)
        alt + shift - q : yabai -m window --close
        alt + ctrl - q : wezterm

        # workspace prev/next - w
        alt - w  : yabai -m space --focus prev
        alt + shift - w  : yabai -m space --focus next
        alt + ctrl - w  : yabai -m window --display next
        ctrl + shift - w  : yabai -m window --display prev

        # split managent - a
        alt - a : yabai -m window --toggle split

        # resizing, reloading - r
        alt - r : yabai -m space --balance

        # layout handling (spaces) - t
        alt - t : yabai -m space -- layout stack
        alt + shift - t : yabai -m space -- layout bsp
        alt + ctrl - t : yabai -m space -- layout float

        # layout handling (windows) - p
        alt - p : yabai -m window --toggle float
        alt + shift - p : yabai -m window --toggle stack

        # workspace history switching - tab
        alt + ctrl - tab: yabai -m space --focus recent
      '';
  };
}
