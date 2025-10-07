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
      matches = [
        {
          app-id = "^firefox$";
          at-startup = true;
        }
        {
          app-id = "^zen-beta$";
          at-startup = true;
        }
        {
          app-id = "^zen$";
          at-startup = true;
        }
      ];
      open-on-workspace = "browser";
    }
    {
      matches = [
        {
          app-id = "^vesktop$";
          at-startup = true;
        }
        {
          app-id = "^discord$";
          at-startup = true;
        }
        {
          app-id = "^org.telegram.desktop$";
          at-startup = true;
        }
        {
          app-id = "^Signal$";
          at-startup = true;
        }
      ];
      open-on-workspace = "chat";
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
        relative-to = "bottom-right";
      };
    }
    {
      matches = [
        {app-id = "^steam_app_default$";}
        {app-id = "^net.lutris.Lutris$";}
      ];
      open-on-workspace = "vidya";
      open-floating = true;
    }
    {
      matches = [
        {app-id = "^spotify$";}
        {title = "^ncspot$";}
      ];
      open-on-workspace = "media";
    }
    {
      matches = [
        {app-id = "^thunderbird$";}
      ];
      open-on-workspace = "mail";
    }
    {
      matches = [
        {app-id = "^com.github.wwmm.easyeffects$";}
        {app-id = "^.blueman-manager-wrapped$";}
        {app-id = "^org.pulseaudio.pavucontrol$";}
        {app-id = "^com.saivert.pwvucontrol$";}
      ];
      open-on-workspace = "audio";
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
