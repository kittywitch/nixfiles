{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sidequest
    gsettings-desktop-schemas
  ];
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
