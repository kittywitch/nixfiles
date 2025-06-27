{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
  };
  services.clipboard-sync.enable = true;
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
  };
}
