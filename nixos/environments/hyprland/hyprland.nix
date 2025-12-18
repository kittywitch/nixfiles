{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    #package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    #portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
  };

  services = {
    noctalia-shell.enable = true;
    clipboard-sync.enable = true;
  };
  /*
    services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
  };
  */
}
