{ config, lib, pkgs, ... }: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.role.development {
    home.packages = [
      pkgs.deadnix
    ];
  };
}
