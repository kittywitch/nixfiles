{pkgs, ...}: {
  hardware.graphics = {
    enable32Bit = true;
    extraPackages32 = with pkgs; [
      driversi686Linux.mesa
    ];
  };
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
  };
  environment.systemPackages = with pkgs; [
    protonplus
    (lutris.override {
      extraPkgs = pkgs: [
        #pkgs.gamescope
        #pkgs.libnghttp2
        #pkgs.winetricks
        #pkgs.jansson
        #pkgs.samba
        #pkgs.gvfs
        #pkgs.mangohud
        #pkgs.vkbasalt
        #pkgs.umu-launcher
        #pkgs.xdg-desktop-portal
      ];
      extraLibraries = pkgs: [
        #pkgs.libunwind
        #pkgs.xdg-desktop-portal
        #pkgs.gvfs
        #pkgs.jansson
        #pkgs.samba
        #pkgs.xz
      ];
    })

    vkbasalt
    mangohud
    umu-launcher
    winetricks
  ];
}
