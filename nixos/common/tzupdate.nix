_: {
  services.tzupdate.enable = true;

  systemd.timers."tzupdate" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "tzupdate.service";
    };
  };
}
