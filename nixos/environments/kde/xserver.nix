{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xclip
    wl-clipboard
  ];
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.desktopManager.plasma6.enable = true;
}
