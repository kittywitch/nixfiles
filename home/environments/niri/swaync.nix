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
    };
  };
}
