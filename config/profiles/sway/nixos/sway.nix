{ config, pkgs, lib, sources, ... }:

{
  config = lib.mkIf config.deploy.profile.sway { programs.sway.enable = true; };
}
