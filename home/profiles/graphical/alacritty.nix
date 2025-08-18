{pkgs, ...}: {
  stylix.targets.alacritty.enable = true;
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty-graphics;
    settings = {
    };
  };
}
