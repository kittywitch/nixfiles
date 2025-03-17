{ lib, ... }: let
  inherit (lib) mkForce;
in {
  catppuccin = {
    enable = true;
    flavor = "frappe";
    gtk = {
      enable = true;
      icon.enable = true;
      gnomeShellTheme = mkForce false;
    };
  };
  dconf.settings = mkForce { };
  gtk.enable = true;
}
