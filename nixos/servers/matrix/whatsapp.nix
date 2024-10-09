{config, ...}: {
  sops.secrets.mautrix-whatsapp-environment = {
    sopsFile = ./whatsapp.yaml;
  };
  services.mautrix-whatsapp = {
    #inherit (config.services.matrix-synapse) enable;
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
        encryption = {
          allow = true;
          default = true;
          require = true;
        };
        permissions = {
          "kittywit.ch" = "full";
          "@whatsapp:kittywit.ch" = "admin";
          "@kat:kittywit.ch" = "admin";
        };
      };
    };
  };
}
