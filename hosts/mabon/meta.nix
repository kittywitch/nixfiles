{ config, hosts, ... }: {
  config = {
    resources.mabon = {
      provider = "null";
      type = "resource";
      connection = {
        port = 62954;
        host = "192.168.1.119";
      };
    };
    deploy.systems.mabon = with config.resources; {
      nixosConfig = hosts.mabon.config;
      connection = mabon.connection.set;
      triggers.copy.mabon = mabon.refAttr "id";
      triggers.secrets.mabon = mabon.refAttr "id";
    };
  };
}
