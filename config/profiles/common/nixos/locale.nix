{ config, lib, pkgs, sources, ... }:

{
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };
}
