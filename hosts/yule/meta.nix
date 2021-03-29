{ config, hosts, ... }: {
  config = {
    resources.yule = {
      provider = "null";
      type = "resource";
      connection = {
        port = 62954;
        host = "192.168.1.92";
      };
    };
    deploy.systems.yule = with config.resources; {
      nixosConfig = hosts.yule.config;
      connection = yule.connection.set;
      triggers.copy.yule = athame.refAttr "id";
      triggers.secrets.yule = athame.refAttr "id";
    };
  };
}
