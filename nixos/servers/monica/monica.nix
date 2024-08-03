{config, ...}: {
  sops.secrets.monica_appkey = {
    sopsFile = ./secrets.yaml;
    owner = config.services.monica.user;
    inherit (config.services.monica) group;
  };
  services.monica = {
    enable = true;
    hostname = "monica.kittywit.ch";
    appURL = "https://monica.kittywit.ch";
    appKeyFile = config.sops.secrets.monica_appkey.path;
    nginx = {
      serverName = "monica.kittywit.ch";
      serverAliases = [
        "monica.kittywit.ch"
      ];
      enableACME = true;
      forceSSL = true;
    };
  };
}
