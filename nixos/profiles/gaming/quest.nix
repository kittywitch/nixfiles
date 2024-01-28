{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    questpatcher
    sidequest
  ];
  programs.adb.enable = true;
  users.users.kat.extraGroups = ["adbusers"];
}
