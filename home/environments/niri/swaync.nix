_: {
  stylix.targets.swaync.enable = true;
  systemd.user.services.swaync = {
    Service = {
      Environment = [
        "GSK_RENDERER=gl"
        "GTK_DISABLE_VULKAN=1"
      ];
    };
  };
  services.swaync = {
    enable = false;
    settings = {
      positionX = "right";
      positionY = "top";
      layer-shell = true;
      layer = "overlay";
      control-center-layer = "top";
      widgets = ["mpris" "dnd" "title" "notifications" "inhibitors" "backlight" "volume"];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "";
        };
        dnd = {
          text = " DND";
        };
        mpris = {
          image-size = 60;
          image-radius = 12;
        };
      };
    };
  };
}
