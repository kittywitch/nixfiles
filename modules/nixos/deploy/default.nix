{ config, pkgs, lib, options, ... }:

with lib;

{
  options = {
    deploy = {
      groups = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
    };
  };

  config = {
    deploy.groups = [ "all" ];
  };
}
