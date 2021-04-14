{ config, hosts, ... }: {
  config = {
    resources.ostara = {
      provider = "null";
      type = "resource";
      connection = {
        port = 62954;
        host = "192.168.1.245";
      };
    };
    deploy.systems.ostara = with config.resources; {
      nixosConfig = hosts.ostara.config;
      connection = ostara.connection.set;
      triggers.copy.ostara = ostara.refAttr "id";
      triggers.secrets.ostara = ostara.refAttr "id";
    };
  };
}
