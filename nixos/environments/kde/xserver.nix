{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xclip
    wl-clipboard
    libsForQt5.qtstyleplugin-kvantum
     qt6Packages.qtstyleplugin-kvantum

  ];
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };
    desktopManager.plasma6.enable = true;
  };
}
