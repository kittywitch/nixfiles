{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };
}
