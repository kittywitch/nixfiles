{ std, ... }: let
  inherit (std) list;
in {
  wayland.windowManager.hyprland.settings.workspace = let
        commonOptions = "gapsin:0,gapsout:0,rounding:false";
      in
        ["1,monitor:DP-1,default:true,${commonOptions}"]
        ++ (list.map (
          workspace: "${toString workspace},monitor:DP-1${commonOptions}"
        ) (list.range 2 10))
        ++ ["11,monitor:HDMI-A-1,default:true"]
        ++ (list.map (
          workspace: "${toString workspace},monitor:HDMI-A-1${commonOptions}"
        ) (list.range 12 20));
}
