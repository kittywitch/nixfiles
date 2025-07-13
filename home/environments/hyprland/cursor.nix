{pkgs, ...}: {
  home.pointerCursor = {
    enable = true;
    package = pkgs.graphite-cursors;
    size = 16;
    name = "graphite-dark";
  };
}
