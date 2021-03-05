{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    services.nextcloud-client.enable = true;
  };
}
