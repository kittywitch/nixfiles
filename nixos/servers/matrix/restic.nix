{config, ...}: {
  sops.secrets.restic-password-file = {
    sopsFile = ./restic.yaml;
  };
  services.restic.backups = {
    "${config.networking.hostName}/matrix" = {
      paths = [
        "/var/lib/matrix-synapse"
        "/var/lib/mx-puppet-discord"
        "/var/lib/mautrix-whatsapp"
        "/var/lib/mautrix-signal"
        "/var/lib/mautrix-telegram"
      ];
      exclude = [
      ];
      extraOptions = [
        "sftp.command='ssh u401227@u401227.your-storagebox.de -i /home/kat/.ssh/id_ed25519 -s sftp'"
      ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 2"
        "--keep-monthly 6"
      ];
      initialize = true;
      passwordFile = config.sops.secrets.restic-password-file.path;
      repository = "sftp:u401227@u401227.your-storagebox.de:/restic/yukari/matrix";
      timerConfig = {
        OnCalendar = "00:05";
        RandomizedDelaySec = "5h";
      };
    };
  };
}
