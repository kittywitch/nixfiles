{ config, hosts, ... }: {
  config = {
    resources.athame = {
      provider = "null";
      type = "resource";
      connection = {
        port = 62954;
        host = "athame.kittywit.ch";
      };
    };
    deploy.systems.athame = with config.resources; {
      nixosConfig = hosts.athame.config;
      connection = athame.connection.set;
      triggers.copy.athame = athame.refAttr "id";
      triggers.secrets.athame = athame.refAttr "id";
    };
  };
}
