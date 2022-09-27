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
  options.deploy.tf = mkOption {
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

  config = let
    functionlessConfig = lib.removeAttrs config ["out" "_module" "platform" "deploy"];
    mutatedConfig = functionlessConfig // (optionalAttrs (config.platform != {}) {
      ${functionlessConfig.esphome.platform} = config.platform;
    });
    jsonConfig = builtins.toJSON mutatedConfig;
    closureConfig = pkgs.writeText "${functionlessConfig.esphome.name}.json" jsonConfig;
    closure-upload = pkgs.writeShellScriptBin "${functionlessConfig.esphome.name}-upload" ''
      '';
    in {
    deploy.tf = {
        attrs = [ "import" "imports" "out" "attrs" "triggers" ];
        import = genAttrs cfg.tf.imports (target: meta.deploy.targets.${target}.tf);
        out.set = removeAttrs cfg.tf cfg.tf.attrs;
        triggers = {
          compile = {
            system = config.out;
          };
        };
        resources = {
          "${name}-upload" = {
            provider = "null";
            type = "resource";
            inputs.triggers = cfg.tf.triggers.compile;
            provisioners = [
              {
                type = "local-exec";
                local-exec.command = ''
                  ${pkgs.esphome}/bin/esphome upload ${closureConfig}
                '';
              }
            ];
          };
        };
      };

    _module.args.tf = mapNullable (target: target.tf) target;
  };
}

