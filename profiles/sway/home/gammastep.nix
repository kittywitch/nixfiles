{ config, lib, ... }:

{
    services.gammastep = {
      enable = true;
      latitude = "51.5074";
      longitude = "0.1278";
    };
}
