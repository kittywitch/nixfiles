{ config, ... }: {
  programs.adb.enable = false;
  users.users.kat.extraGroups = [ "adbusers" ];
}
