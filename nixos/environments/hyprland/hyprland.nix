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

  # auto launch hyprland on tty1
  environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
    fi
  '';
  
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
