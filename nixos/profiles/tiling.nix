{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  security.pam.loginLimits = [
    { domain = "*"; type = "soft"; item = "nofile"; value = "65536"; }
    { domain = "*"; type = "hard"; item = "nofile"; value = "1048576"; }
  ];
  services.noctalia-shell.enable = true;
  programs.regreet = {
    enable = true;
    theme = mkForce config.home-manager.users.kat.gtk.theme;
  };
  stylix.targets.regreet.enable = true;
  services.greetd = {
    enable = true;
  };
}
