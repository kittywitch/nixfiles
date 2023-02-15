{ config, ... }: {
  systemd.user.services.waybar.Unit.X-Restart-Triggers = [
    (builtins.toString config.programs.waybar.style)
  ];
}
