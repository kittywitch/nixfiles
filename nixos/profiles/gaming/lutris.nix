{pkgs, ...}: {
  hardware.opengl = {
    driSupport32Bit = true;
  };
  hardware.graphics = {
    enable32Bit = true;
    extraPackages32 = with pkgs; [
      driversi686Linux.mesa
    ];
  };
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [
        pkgs.libnghttp2
        pkgs.winetricks
        pkgs.jansson
        pkgs.samba
      ];
      extraLibraries = pkgs: [
        pkgs.jansson
        pkgs.samba
        pkgs.xz
      ];
    })

    # support 32-bit only
    wine

    # support 64-bit only
    wine64

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
  ];
}
