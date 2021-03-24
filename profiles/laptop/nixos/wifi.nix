{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.deploy.profile.laptop { };
}
