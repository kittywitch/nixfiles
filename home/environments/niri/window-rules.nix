_: {
  programs.niri.settings.window-rules = [
    {
      draw-border-with-background = false;
      clip-to-geometry = true;
      geometry-corner-radius = let
        r = 5.0;
      in {
        bottom-left = r;
        bottom-right = r;
        top-left = r;
        top-right = r;
      };
    }

    {
      matches = [{app-id = "^firefox$";}];
      open-on-workspace = "browser";
    }
    {
      matches = [
        {app-id = "^vesktop$";}
        {app-id = "^discord$";}
        {app-id = "^org.telegram.desktop$";}
      ];
      open-on-workspace = "chat";
    }
    {
      matches = [{app-id = "^steam_app_default$";}];
      open-on-workspace = "vidya";
      open-floating = true;
    }
    {
      matches = [{app-id = "^spotify$";}];
      open-on-workspace = "media";
    }
    {
      matches = [
        {
          app-id = "steam";
          title = "^notificationtoasts_\d+_desktop$";
        }
      ];
      default-floating-position = {
        x = 10;
        y = 10;
        relative-to = "top-right";
      };
    }
  ];
}
