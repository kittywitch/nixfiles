{config, ...}: {
  sops.secrets.mautrix-telegram-environment = {
    sopsFile = ./telegram.yaml;
  };
  services.mautrix-telegram = {
    #inherit (config.services.matrix-synapse) enable;
    environmentFile = config.sops.secrets.mautrix-telegram-environment.path;
    settings = {
      homeserver = {
        domain = "kittywit.ch";
        address = "https://yukari.gensokyo.zone";
        software = "standard";
      };
      appservice = {
        port = 9047;
      };
      telegram = {
      };
      bridge = {
        permissions = {
          "kittywit.ch" = "full";
          "@kat:kittywit.ch" = "admin";
        };
      };
    };
  };
}
