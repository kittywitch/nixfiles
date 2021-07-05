{ tf, target, name, meta, config, lib, ... }:
with lib;
let
  cfg = config.deploy;
  unmergedValues = types.mkOptionType {
    name = "unmergedValues";
    merge = loc: defs: map (def: def.value) defs;
  };
in
{
  options.deploy = {
    targetName = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    system = mkOption {
      type = types.unspecified;
      readOnly = true;
    };
  };
  options.deploy.tf = mkOption {
    type = types.submodule {
      freeformType = types.attrsOf unmergedValues;

      options = {
        import = mkOption {
          type = types.attrsOf types.unspecified;
          default = [ ];
        };
        imports = mkOption {
          type = types.listOf types.str;
          description = "Other targets to depend on";
          default = [ ];
        };
        attrs = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
        out.set = mkOption { type = types.unspecified; };
      };
    };
  };

  config = {
    deploy = {
      system = config.system.build.toplevel;
      targetName = if (meta.deploy.targets ? ${name}) then 
      (mkDefault name)
      else
      head (attrNames ((filterAttrs(targetName: target: elem config.networking.hostName target.nodeNames) meta.deploy.targets)));
    };
    deploy.tf = mkMerge (singleton
      {
        attrs = [ "import" "imports" "out" "attrs" ];
        import = genAttrs cfg.tf.imports (target: meta.deploy.targets.${target}.tf);
        out.set = removeAttrs cfg.tf cfg.tf.attrs;
        deploy.systems.${config.networking.hostName} =
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

        dns.records."kittywitch_net_${config.networking.hostName}" =
          mkIf (config.hexchen.network.enable) {
            tld = "kittywit.ch.";
            domain = "${config.networking.hostName}.net";
            aaaa.address = config.hexchen.network.address;
          };

      } ++ mapAttrsToList
      (_: user:
        mapAttrs (_: mkMerge) user.deploy.tf.out.set)
      config.home-manager.users);

    security.acme.certs."${config.networking.hostName}.net.kittywit.ch" =
      mkIf (config.services.nginx.enable && config.hexchen.network.enable) {
        domain = "${config.networking.hostName}.net.kittywit.ch";
        dnsProvider = "rfc2136";
        credentialsFile = config.secrets.files.dns_creds.path;
        group = "nginx";
      };
    _module.args.target = mapNullable (targetName: meta.deploy.targets.${targetName}) cfg.targetName;
    _module.args.tf = mapNullable (target: target.tf) target;
  };
}
