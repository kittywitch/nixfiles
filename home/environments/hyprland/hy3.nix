{ config, ... }:

{
  wayland.windowManager.hyprland.settings = {
    general.layout = "hy3";
    plugin.hy3 = with config.stylix.generated.palette; {
      tabs = {
        height = 30;
        text_font = config.stylix.fonts.sansSerif.name;
        text_height = config.stylix.fonts.sizes.desktop;
        border_width = 1;

        "col.urgent" = "rgb(${base08})";
        "col.urgent.border" = "rgb(${base08})";
        "col.urgent.text" = "rgb(${base05})";
        "col.inactive" = "rgb(${base03})";
        "col.inactive.border" = "rgb(${base03})";
        "col.inactive.text" = "rgb(${base01})";
        "col.active" = "rgb(${base0D})";
        "col.active.border" = "rgb(${base0D})";
        "col.active.text" = "rgb(${base05})";
      };
      autotitle = {
        trigger_width = 800;
        trigger_height = 500;
      };
    };
  };
}
