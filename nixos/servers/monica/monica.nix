{ config, ... }: {
  sops.secrets.monica_appkey = {
    sopsFile = ./secrets.yaml;
    owner = config.services.monica.user;
    group = config.services.monica.group;
  };
  services.monica = {
    enable = true;
    appURL = "https://monica.kittywit.ch";
    appKeyFile = config.sops.secrets.monica_appkey.path;
    nginx = {
      serverAliases = [
        "monica.kittywit.ch"
      ];
      enableACME = true;
      forceSSL = true;
    };
  };
}
