{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xclip
    wl-clipboard
  ];
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
