{
  pkgs,
  inputs,
  ...
}: {
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
    (lutris.override {
      extraLinkLines = let
      proton-cachyos = inputs.nix-proton-cachyos.packages.${pkgs.system}.proton-cachyos;
        in ''ln -sf ${proton-cachyos}/share/steam $out/share'';
      extraPkgs = pkgs: [
        pkgs.gamescope
        pkgs.libnghttp2
        pkgs.winetricks
        pkgs.jansson
        pkgs.samba
        pkgs.gvfs
        pkgs.mangohud
        pkgs.vkbasalt
        pkgs.umu-launcher
        pkgs.xdg-desktop-portal
        inputs.nix-proton-cachyos.packages.${pkgs.system}.proton-cachyos
      ];
      extraLibraries = pkgs: [
        pkgs.libunwind
        pkgs.xdg-desktop-portal
        pkgs.gvfs
        pkgs.jansson
        pkgs.samba
        pkgs.xz
        inputs.nix-proton-cachyos.packages.x86_64-linux.proton-cachyos
      ];
    })

    vkbasalt
    mangohud
    umu-launcher

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
