{ config, lib, ... }:

with lib;

let
  secretType = types.submodule ({ name, ... }: {
    options = {
      source = mkOption {
        type = types.path;
      };
      text = mkOption {
        type = types.str;
      };
    };
  });
in
{
  options.kw = {
    secrets = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
    };
    repoSecrets = mkOption {
      type = types.nullOr (types.attrsOf secretType);
      default = null;
    };
  };
  config = mkIf (config.kw.secrets != null) {
    deploy.tf.variables = genAttrs config.kw.secrets (n: { externalSecret = true; });
  };
}
