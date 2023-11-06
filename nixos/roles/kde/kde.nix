{tree, ...}: {
  imports = with tree.nixos.roles; [
    graphical
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.dconf.enable = true;
}
