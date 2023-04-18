{ config, lib, pkgs, ... }: with lib;

let cfg = config.programs.swaylock; in
{
  options.programs.swaylock = {
    colors = mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
  };
  config.programs.swaylock.settings = mapAttrs' (arg: color: nameValuePair ("${arg}-color") (removePrefix "#" color)) cfg.colors;
}
