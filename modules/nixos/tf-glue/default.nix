{ tf, target, config, lib, ... }:
with lib;
let
  cfg = config.deploy.tf;
  unmergedValues = types.mkOptionType {
    name = "unmergedValues";
    merge = loc: defs: map (def: def.value) defs;
  };
in {
  options.deploy.tf = mkOption {
    type = types.submodule {
      freeformType = types.attrsOf unmergedValues;

      options = {
        attrs = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
        out.set = mkOption { type = types.unspecified; };
      };
    };
  };

  config = {
    deploy.tf = {
      attrs = [ "out" "attrs" ];
      out.set = removeAttrs cfg cfg.attrs;
    };

    deploy.tf.deploy.systems.${config.networking.hostName} =
      with tf.resources; {
        isRemote =
          (config.networking.hostName != builtins.getEnv "HOME_HOSTNAME");
        nixosConfig = config;
        connection = tf.resources.${config.networking.hostName}.connection.set;
        triggers.copy.${config.networking.hostName} =
          tf.resources.${config.networking.hostName}.refAttr "id";
        triggers.secrets.${config.networking.hostName} =
          tf.resources.${config.networking.hostName}.refAttr "id";
      };

    deploy.tf.dns.records."kittywitch_net_${config.networking.hostName}" =
      mkIf (config.hexchen.network.enable) {
        tld = "kittywit.ch.";
        domain = "${config.networking.hostName}.net";
        aaaa.address = config.hexchen.network.address;
      };

    security.acme.certs."${config.networking.hostName}.net.kittywit.ch" =
      mkIf (config.services.nginx.enable && config.hexchen.network.enable) {
        domain = "${config.networking.hostName}.net.kittywit.ch";
        dnsProvider = "rfc2136";
        credentialsFile = config.secrets.files.dns_creds.path;
        group = "nginx";
      };
    _module.args.tf = target.${config.deploy.target};
  };
}
