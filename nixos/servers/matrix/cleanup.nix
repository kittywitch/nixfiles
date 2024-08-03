{
  config,
  pkgs,
  ...
}: {
  sops.secrets.synapse-cleanup-environment = {
    sopsFile = ./secrets.yaml;
  };
  systemd = {
    services.synapse-cleanup = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        EnvironmentFile = config.sops.secrets.synapse-cleanup-environment.path;
        ExecStart = "${pkgs.synapse-cleanup}/bin/synapse-cleanup";
      };
    };
    timers.synapse-cleanup = {
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
        Unit = "synapse-cleanup.service";
      };
      wantedBy = ["timers.target"];
    };
  };
}
