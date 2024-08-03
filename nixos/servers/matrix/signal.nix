{config, ...}: {
  sops.secrets.mautrix-signal-environment = {
    sopsFile = ./signal.yaml;
  };
  services.mautrix-signal = {
    inherit (config.services.matrix-synapse) enable;
    environmentFile = config.sops.secrets.mautrix-signal-environment.path;
    settings = {
      homeserver = {
        domain = "kittywit.ch";
        address = "https://yukari.gensokyo.zone";
        software = "standard";
      };
      appservice = {
        port = 9048;
        ephemeral_events = false;
      };
      signal = {
      };
      bridge = {
        history_sync = {
          request_full_sync = true;
        };
        private_chat_portal_meta = true;
        mute_bridging = true;
        encryption = {
          allow = true;
          default = true;
          require = true;
        };
        provisioning = {
          shared_secret = "disable";
        };
        permissions = {
          "kittywit.ch" = "full";
          "@kat:kittywit.ch" = "admin";
          "@signal:kittywit.ch" = "admin";
        };
      };
    };
  };
}
