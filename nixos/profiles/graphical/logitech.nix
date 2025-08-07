{pkgs, ...}: {
  services.solaar = {
    enable = truem
    window = "hide";
    package = pkgs.solaar;
    batteryIcons = "regular";
  };
}
