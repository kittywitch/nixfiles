{ config, lib, ... }: let
  inherit (lib.modules) mkIf;
in mkIf (config.programs.waybar.enable) {
  systemd.user.services.waybar.Unit.X-Restart-Triggers = [
    (builtins.toString config.programs.waybar.style)
  ];
}
