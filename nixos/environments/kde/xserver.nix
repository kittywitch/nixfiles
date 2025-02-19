{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xclip
    wl-clipboard
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    commonalitysol
  ];
  environment.plasma6.excludePackages = with pkgs; [konsole];
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "CommonalitySol";
    };
    xserver = {
      enable = true;
    };
    desktopManager.plasma6.enable = true;
  };
}
