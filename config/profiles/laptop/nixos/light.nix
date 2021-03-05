{ config, lib, pkgs, ... }:

{
  config =
    lib.mkIf config.deploy.profile.laptop { programs.light.enable = true; };
}
