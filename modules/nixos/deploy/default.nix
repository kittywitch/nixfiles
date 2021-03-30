{ config, pkgs, lib, options, ... }:

with lib;

{
  options = {
    deploy = {
      target = mkOption {
        type = with types; str;
        default = "";
      };
    };
  };
}
