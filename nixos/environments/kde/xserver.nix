{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    xclip
  ];
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}
