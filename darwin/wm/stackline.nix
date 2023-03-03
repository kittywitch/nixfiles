{pkgs, ...}: {
  homebrew.casks = [
    "hammerspoon"
  ];
  system.defaults.CustomUserPreferences = {
    "org.hammerspoon.Hammerspoon" = {
      MJConfigFile = "${pkgs.stackline}/init.lua";
    };
  };
}
