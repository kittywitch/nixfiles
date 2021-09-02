{ config, nixos, lib, ... }:

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
  config = {
    kw.secrets.repo = nixos.kw.secrets.repo;
  };
}
