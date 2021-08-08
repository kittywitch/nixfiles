{ config, lib, ... }:

with lib;

{
  options.kw = {
    secrets = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
    };
  };
  config = mkIf (config.kw.secrets != null) {
    deploy.tf.variables = genAttrs config.kw.secrets (n: { externalSecret = true; });
  };
}
