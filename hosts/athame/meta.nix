{ config, hosts, lib, ... }: {
  config = {
    resources.athame = {
      provider = "null";
      type = "resource";
      connection = {
        port = 62954;
        host = "athame.kittywit.ch";
      };
    };

    dns.records.kittywitch_athame = {
      tld = "kittywit.ch.";
      domain = "athame";
      a.address = "168.119.126.111";
    };

    dns.records.kittywitch_root = {
      tld = "kittywit.ch.";
      domain = "@";
      a.address = "168.119.126.111";
    };

    deploy.systems.athame = with config.resources; {
      nixosConfig = hosts.athame.config;
      connection = athame.connection.set;
      triggers.copy.athame = athame.refAttr "id";
      triggers.secrets.athame = athame.refAttr "id";
      #triggers.switch = lib.mapAttrs (name: record: { 
      #A = config.lib.tf.terraformExpr ''join(",", ${record.out.resource.namedRef}.addresses)'';
      #AAAA = config.lib.tf.terraformExpr ''join(",", ${record.out.resource.namedRef}.addresses)'';
      #CNAME = record.out.resource.refAttr "cname";
      #SRV = record.out.resource.refAttr "id";
      #}.${record.out.type}) config.dns.records;
  };
  };
}
