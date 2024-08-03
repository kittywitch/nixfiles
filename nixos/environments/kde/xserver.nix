{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xclip
    wl-clipboard
  ];
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };
    desktopManager.plasma6.enable = true;
  };
}
