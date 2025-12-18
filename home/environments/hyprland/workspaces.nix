{ std, ... }: let
  inherit (std) list;
in {
  wayland.windowManager.hyprland.settings.workspace = let
        commonOptions = "gapsin:5,gapsout:5,rounding:true,persistent:true";
      in
        ["1,default:true,${commonOptions}"]
        ++ (list.map (
          workspace: "${toString workspace},${commonOptions}"
        ) (list.range 2 10))
        ++ ["11,${commonOptions}"]
        ++ (list.map (
          workspace: "${toString workspace},${commonOptions}"
        ) (list.range 12 20));
}
