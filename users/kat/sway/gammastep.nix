{ config, lib, ... }:

{
  services.gammastep = {
    enable = true;
    tray = true;
    latitude = "43.6532";
    longitude = "79.3832";
  };
}
