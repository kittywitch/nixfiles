{pkgs, config, lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  programs.regreet = {
    enable = true;
    theme = mkForce config.home-manager.users.kat.gtk.theme;
  };
  stylix.targets.regreet.enable = true;
  services.greetd = {
    enable = true;
  };
}
