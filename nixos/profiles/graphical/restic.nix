{config, ...}: {
  sops.secrets.restic-password-file = {
    sopsFile = ./restic.yaml;
  };
  services.restic.backups = {
    ${config.networking.hostName} = {
      paths = [
        "/home/kat/Documents"
        "/home/kat/Pictures"
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
      repository = "sftp:u401227@u401227.your-storagebox.de:/restic/${config.networking.hostName}";
      timerConfig = {
        OnCalendar = "00:05";
        RandomizedDelaySec = "5h";
      };
    };
  };
}
