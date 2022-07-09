{ config, pkgs, ... }:

{
  fonts.fonts = [
    pkgs.tamzen
  ];
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  console = {
    packages = [ pkgs.tamzen ];
    keyMap = "uk";
  };
}
