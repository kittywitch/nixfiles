{ pkgs, config, lib, ... }: let
  inherit (lib.modules) mkOptionDefault;
in {

  home.sessionVariables.SWAY_UNSUPPORTED_GPU = 1;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      layer = "top";
      position = "top";
      modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
      modules-right = [ "clock" ];
      clock = {
        format = "{:%F %T %Z}";
        interval = 1;
      };
    };
    style = ''
      * {
        font-family: "Atkinson Hyperlegible Next", monospace;
        font-size: 16px;
      }
    '';
  };
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    swaynag.enable = true;
    extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    extraConfig = ''
      blur enable
      shadows enable
    '';
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      output = {
        "LG Electronics LG Ultra HD 0x0001AC91" = {
          mode = "2560x1440@59.951Hz";
        };
      };
      keybindings = mkOptionDefault {
      };
      bars = [
          {
            command = "${pkgs.waybar}/bin/waybar";
          }
        ];
    };
  };
}
