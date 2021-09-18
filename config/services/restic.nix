{ config, lib, pkgs, ... }:

{
  services.restic.backups.tardis = {
    passwordFile = "/etc/restic/system";
    paths = [ "/home" "/var/lib" ];
    pruneOpts = [ "--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12" ];
    repository = "";
  };
  systemd.services."restic-backups-tardis".environment.RESTIC_REPOSITORY_FILE =
    "/etc/restic/system.repo";
  services.postgresqlBackup = {
    enable = config.services.postgresql.enable;
    backupAll = true;
    startAt = "*-*-* 23:45:00";
  };
}
