_: {
  services.tzupdate.enable = true;
  systemd.timers.tzupdate = {
    description = "Attempt to update timezone every hour";
    timerConfig = {
      OnBootSec="1m";
      OnUnitInactiveSec="1h";
      Unit = "tzupdate.service";
    };
    wantedBy = [ "timers.target" ];
  };
}
