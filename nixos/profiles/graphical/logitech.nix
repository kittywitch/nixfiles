{pkgs, ...}: {
  services.solaar = {
    enable = true;
    window = "hide";
    package = pkgs.solaar;
    batteryIcons = "regular";
  };
}
