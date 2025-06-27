{config, ...}: {
  sops.secrets = {
    restic-ssh-keyfile = {
      sopsFile = ./restic.yaml;
    };
    restic-password-file = {
      sopsFile = ./restic.yaml;
    };
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
        "sftp.command='ssh -p 23 u401227@u401227.your-storagebox.de -i ${config.sops.secrets.restic-ssh-keyfile.path} -s sftp'"
      ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 2"
        "--keep-monthly 6"
      ];
      initialize = true;
      passwordFile = config.sops.secrets.restic-password-file.path;
      repository = "sftp:u401227@u401227.your-storagebox.de:/home/restic/${config.networking.hostName}";
      timerConfig = {
        OnCalendar = "12:00";
        RandomizedDelaySec = "2h";
      };
    };
  };
}
