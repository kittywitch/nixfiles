{ config, ... }: {
  services.udev.extraRules = ''
# SteelSeries Arctis (1) Wireless
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="12b3", GROUP="users", MODE="0666"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1038", ATTRS{idProduct}=="12b6", GROUP="users", MODE="0666"
  '';
}
