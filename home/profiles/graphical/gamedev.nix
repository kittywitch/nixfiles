{pkgs, ...}: {
  home.packages = with pkgs; [
    tiled
    aseprite
  ];
}
