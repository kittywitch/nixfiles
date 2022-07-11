{ config, lib, meta, ... }:

with lib;

let
  mcfg = meta.kw.secrets;
  cfg = config.kw.secrets;
in
{
  config = mkIf (cfg.variables != { }) {
      deploy.tf.variables = mapAttrs'
        (name: content:
          nameValuePair name ({
            value.shellCommand = "${mcfg.command} ${content.path}" + optionalString (content.field != "") " -f ${content.field}";
            type = "string";
            sensitive = true;
          })
        )
        cfg.variables;
    };
}
