{ config, lib, ... }:

/*
This module:
  * Provides in-scope TF config for home-manager.
*/

with lib;

let
  cfg = config.deploy.tf;
  unmergedValues = types.mkOptionType {
    name = "unmergedValues";
    merge = loc: defs: map (def: def.value) defs;
  };
in
{

  options.deploy.tf = mkOption {
    type = types.submodule {
      freeformType = types.attrsOf unmergedValues;

      options = {
        attrs = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
        out.set = mkOption { type = types.unspecified; };
      };
    };

  };
  config = {
    deploy.tf = {
      attrs = [ "out" "attrs" ];
      out.set = removeAttrs cfg cfg.attrs;
    };
  };
}
