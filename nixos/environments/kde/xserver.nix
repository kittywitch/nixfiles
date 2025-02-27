{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xclip
    wl-clipboard
    kwin-blishhud-shader
  ];
  environment.plasma6.excludePackages = with pkgs; [konsole];
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    xserver = {
      enable = true;
    };
    desktopManager.plasma6.enable = true;
  };
}
