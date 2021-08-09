{ config, lib, ... }:

with lib;

{
  options = let tf = config; in {
    variables = mkOption {
      type = types.attrsOf (types.submodule ({ name, config, ... }: {
        options.externalSecret = mkEnableOption "Is ths secret to be templated into a command provided?";
        config = mkIf config.externalSecret {
          type = "string";
          value.shellCommand = "${tf.commandPrefix} ${tf.folderPrefix}${tf.folderDivider}${escapeShellArg name}";
          sensitive = true;
        };
      }));
    };
    commandPrefix = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    folderPrefix = mkOption {
      type = types.str;
      default = "";
    };
    folderDivider = mkOption {
      type = types.str;
      default = "";
    };
  };
}
