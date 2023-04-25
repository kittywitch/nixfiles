{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  powerManagement.cpuFreqGovernor = mkDefault "powersave";
  programs.light.enable = true;
  home-manager.sharedModules = [
    {
      programs.waybar.settings.main = {
        modules-right = [
          "backlight"
          "battery"
        ];
        backlight = {
          format = " {percent}%";
          on-scroll-up = "${pkgs.light}/bin/light -A 1";
          on-scroll-down = "${pkgs.light}/bin/light -U 1";
        };
        battery = {
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["" "" "" "" ""];
        };
      };
    }
  ];
}
