{ pkgs, ... }: {
  services.hypridle = {
    enable = true;
    listeners = [
      {
        timeout = 150;
        onTimeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 5";
        onResume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        timeout = 300;
        onTimeout = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        timeout = 330;
        onTimeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        onResume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";

      }
      {
        timeout = 600;
        onTimeout = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
    afterSleepCmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
    lockCmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
    unlockCmd = "${pkgs.psmisc}/bin/killall hyprlock";
  };
}
