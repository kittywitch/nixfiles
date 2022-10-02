{ config, lib, meta, ... }: with lib; {
  config = mkIf (config.secrets.variables != { }) {
      deploy.tf.variables = mapAttrs'
        (name: content:
          nameValuePair name ({
            value.shellCommand = "${meta.secrets.command} ${content.path}" + optionalString (content.field != "") " -f ${content.field}";
            type = "string";
            sensitive = true;
          })
        )
        config.secrets.variables;
    };
}
