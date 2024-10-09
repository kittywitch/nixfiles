{config, ...}: {
  sops.secrets.mautrix-slack-environment = {
    sopsFile = ./slack.yaml;
  };
  services.mautrix-slack = {
    #inherit (config.services.matrix-synapse) enable;
    environmentFile = config.sops.secrets.mautrix-slack-environment.path;
    settings = {
      homeserver = {
        domain = "kittywit.ch";
        address = "https://yukari.gensokyo.zone";
        software = "standard";
      };
      appservice = {
        ephemeral_events = false;
      };
      slack = {
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
          "@slack:kittywit.ch" = "admin";
        };
      };
    };
  };
}
