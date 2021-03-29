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

    resources.athame_test_domain = {
      provider = "dns";
      type = "a_record_set";
      inputs = {
        zone = "kittywit.ch.";
        name = "testy";
        addresses = [
          "168.119.126.111"
        ];
        ttl = 300;
      };
    };

    deploy.systems.athame = with config.resources; {
      nixosConfig = hosts.athame.config;
      connection = athame.connection.set;
      triggers.copy.athame = athame.refAttr "id";
      triggers.secrets.athame = athame.refAttr "id";
      triggers.switch.athame = config.lib.tf.terraformExpr ''join(",", ${athame_test_domain.namedRef}.addresses)'';
    };
  };
}
