_: {
  stylix.targets.swaync.enable = true;
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer-shell = true;
      layer = "overlay";
      control-center-layer = "top";
      widgets = [ "mpris" "dnd" "title" "notifications" "inhibitors" "backlight" "volume"  ];
      widget-config =  {
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
