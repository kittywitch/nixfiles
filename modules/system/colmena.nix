{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib.modules) mkOptionDefault mkDefault;
in {
  options = let
    inherit (lib.types) nullOr;
    inherit (lib.options) mkOption;
  in {
    colmena = mkOption {
      type = nullOr inputs.arcexprs.lib.json.types.attrs;
    };
  };
  config = {
    colmena = {
      targetHost = mkDefault config.deploy.hostname;
      targetUser = mkDefault config.deploy.sshUser;
      tags = mkOptionDefault [
        "all"
      ];
    };
  };
}
