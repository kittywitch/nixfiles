{ tf, target, name, meta, pkgs, config, lib, ... }:

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
in {
  options = {
    out = mkOption {
      type = types.str;
    };
    deploy.tf = mkOption {
    type = types.submodule {
      inherit (unmerged) freeformType;

      options = {
        triggers = mkOption {
          type = types.attrsOf types.unspecified;
          default = { };
        };
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
  };

  config = let
    functionlessConfig = lib.removeAttrs config ["out" "_module" "platform" "deploy" "secrets"];
    mutatedConfig = functionlessConfig // (optionalAttrs (config.platform != {}) {
      ${functionlessConfig.esphome.platform} = config.platform;
    });
    jsonConfig = builtins.toJSON mutatedConfig;
    secretsMap = mapAttrs (name: _: tf.variables."${config.esphome.name}-secret-${name}".ref) config.secrets;
    secretsFile = builtins.toJSON secretsMap;
    closureConfig = pkgs.writeText "${functionlessConfig.esphome.name}.json" jsonConfig;
    in mkMerge [
    {
      _module.args.tf = mapNullable (target: target.tf) target;
      out = jsonConfig;
    deploy.tf = {
        attrs = [ "import" "imports" "out" "attrs" "triggers" ];
        import = genAttrs cfg.tf.imports (target: meta.deploy.targets.${target}.tf);
        out.set = removeAttrs cfg.tf cfg.tf.attrs;
        triggers = {
          upload = {
            system = config.out;
          };
        };
        resources = {
          "${name}-secrets" = {
            provider = "local";
            type = "file";
            inputs = {
              filename = "${tf.terraform.dataDir}/esphome-${name}-secrets.json";
              content = secretsFile;
            };
          };
          "${name}-upload" = {
            provider = "null";
            type = "resource";
            inputs.triggers = cfg.tf.triggers.upload;
            provisioners = [
              {
                type = "local-exec";
                local-exec.command = ''
                  ${pkgs.esphome}/bin/esphome compile ${closureConfig} ${tf.resources."${name}-secrets".refAttr "filename"}
                  ${pkgs.esphome}/bin/esphome upload ${closureConfig} --device ${name}.local
                '';
              }
            ];
          };
        };
      };
    }
    (mkIf (config.secrets != {}) {
      deploy.tf.variables = mapAttrs' (name: content: let
        parts = if hasInfix "#" content then splitString "#" content else content;
        field = head (reverseList parts);
        path = if length parts > 1 then head parts else "password";
      in nameValuePair "${config.esphome.name}-secret-${name}" ({
        value.shellCommand = let
          bitw = pkgs.writeShellScriptBin "bitw" ''${pkgs.rbw-bitw}/bin/bitw -p gpg://${config.network.nodes.all.${builtins.getEnv "HOME_HOSTNAME"}.secrets.repo.bitw.source} "$@"'';
        in "${bitw}/bin/bitw get ${path} -f ${field}";
        type = "string";
        sensitive = true;
      })
    ) config.secrets;
    })
    ];
}

