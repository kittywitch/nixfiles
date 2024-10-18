{config, ...}: {
  services.mx-puppet-discord = {
    #inherit (config.services.matrix-synapse) enable;
    settings = {
      bridge = {
        bindAddress = "localhost";
        domain = "kittywit.ch";
        homeserverUrl = "https://yukari.gensokyo.zone";
      };
      provisioning.whitelist = ["@.*:kittywit.ch"];
      relay.whitelist = ["@.*:kittywit.ch"];
    };
  };
}
