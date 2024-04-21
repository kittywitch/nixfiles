{config, ...}: {
  sops.secrets.mautrix-whatsapp-environment = {
    sopsFile = ./whatsapp.yaml;
  };
  services.mautrix-whatsapp = {
    enable = config.services.matrix-synapse.enable;
    environmentFile = config.sops.secrets.mautrix-whatsapp-environment.path;
    settings = {
      homeserver = {
        domain = "kittywit.ch";
        address = "https://yukari.gensokyo.zone";
        software = "standard";
      };
      appservice = {
        port = 9049;
      };
      whatsapp = {
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
