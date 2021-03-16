{ config, ... }:

{
  programs.adb.enable = true;
  users.users.kat.extraGroups = [ "adbusers" ];
}
