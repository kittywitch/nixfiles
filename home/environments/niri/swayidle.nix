{
  config,
  lib,
  parent,
  ...
}: let
  inherit (lib.meta) getExe;
  noctalia = "${getExe parent.services.noctalia-shell.package} ipc call";
in {
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 600;
        command = "${noctalia} lockScreen toggle";
      }
      {
        timeout = 1200;
        command = "${config.programs.niri.package}/bin/niri msg action power-off-monitors";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${noctalia} lockScreen toggle";
      }
    ];
  };
}
