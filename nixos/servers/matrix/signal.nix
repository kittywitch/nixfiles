{config, ...}: {
  sops.secrets.mautrix-signal-environment = {
    sopsFile = ./signal.yaml;
  };
  services.mautrix-signal = {
    enable = config.services.matrix-synapse.enable;
    environmentFile = config.sops.secrets.mautrix-signal-environment.path;
    settings = {
      homeserver = {
        domain = "kittywit.ch";
        address = "https://yukari.gensokyo.zone";
        software = "standard";
      };
      appservice = {
        port = 9048;
      };
      signal = {
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
