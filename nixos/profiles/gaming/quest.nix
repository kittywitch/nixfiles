{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gsettings-desktop-schemas
    slimevr
    slimevr-server
    inputs.slimevr-wrangler.packages.${pkgs.system}.slimevr-wrangler
  ];
  networking.firewall = {
    allowedUDPPorts = [6969 8266 35903];
    allowedTCPPorts = [21110];
  };
  programs.adb.enable = true;
  users.users.kat.extraGroups = ["adbusers"];
  services.udev.extraRules = ''
    SUBSYSTEM=="usb",ATTR{idVendor}=="2833",ATTR{idProduct}=="0186",MODE="0660",GROUP="adbusers",TAG+="uaccess",SYMLINK+="android",SYMLINK+="android%n"
  '';
  home-manager.users.kat.xdg.systemDirs.data = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  ];
}
