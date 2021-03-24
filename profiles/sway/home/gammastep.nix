{ config, lib, ... }:

{
  config = lib.mkIf config.deploy.profile.sway {
    services.gammastep = {
      enable = true;
      latitude = "51.5074";
      longitude = "0.1278";
    };
  };
}
