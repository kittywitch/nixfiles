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
  };
}
