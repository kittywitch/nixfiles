{ config, lib, meta, ... }:

with lib;

let
  secretType = types.submodule ({ name, ... }: {
    options = {
      path = mkOption { type = types.str; };
      field = mkOption {
        type = types.str;
        default = "";
      };
    };
  });
  repoSecretType = types.submodule ({ name, ... }: {
    options = {
      source = mkOption {
        type = types.path;
      };
      text = mkOption {
        type = types.str;
      };
    };
  });
  mcfg = meta.kw.secrets;
  cfg = config.kw.secrets;
in
{
  options.kw = {
    secrets = {
      variables = mkOption {
        type = types.attrsOf secretType;
        default = { };
      };
      repo = mkOption {
        type = types.attrsOf repoSecretType;
        default = { };
      };
    };
  };
  config = lib.mkMerge [
    {
      kw.secrets.variables = lib.mkMerge (mapAttrsToList (username: user: user.kw.secrets.variables) config.home-manager.users);
    }
    (mkIf (cfg.variables != { }) {
      deploy.tf.variables = mapAttrs'
        (name: content:
          nameValuePair name ({
            value.shellCommand = "${mcfg.command} ${content.path}" + optionalString (content.field != "") " -f ${content.field}";
            type = "string";
            sensitive = true;
          })
        )
        cfg.variables;
    })
  ];
}
