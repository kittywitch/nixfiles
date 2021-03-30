{ config, hosts, ... }: {
  config = {
    resources.samhain = {
      provider = "null";
      type = "resource";
      connection = {
        port = 62954;
        host = "192.168.1.135";
      };
    };
    deploy.systems.samhain = with config.resources; {
      nixosConfig = hosts.samhain.config;
      connection = samhain.connection.set;
      triggers.copy.samhain = samhain.refAttr "id";
      triggers.secrets.samhain = samhain.refAttr "id";
    };
  };
}
