{ tf, target, name, meta, config, lib, ... }:

/*
This module:
  * aliases <hostname>.system.build.toplevel to <hostname>.deploy.system for ease of use.
  * marries meta config to NixOS configs for each host.
  * provides in-scope TF config in NixOS and home-manager, instead of only as a part of meta config.
*/

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
        targetName = let targetsList = attrNames ( filterAttrs (_: target: target.enable && elem name target.nodeNames) meta.deploy.targets ); in
        if (builtins.length targetsList == 0) then null
        else lib.warnIf (builtins.length targetsList > 1) "The host ${name} is assigned to several targets: ${concatMapStrings (x: "${x},") targetsList}." (head targetsList);
      };
      deploy.tf = mkMerge (singleton (lib.mkIf (config.deploy.targetName != null) {
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
      }) ++ mapAttrsToList
      (_: user:
        mapAttrs (_: mkMerge) user.deploy.tf.out.set)
      config.home-manager.users);

    _module.args.target = mapNullable (targetName: meta.deploy.targets.${targetName}) cfg.targetName;
    _module.args.tf = mapNullable (target: target.tf) target;
  };
}
