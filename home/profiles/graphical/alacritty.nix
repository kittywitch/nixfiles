{pkgs, ...}: {
  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "alacritty.desktop" ];
  };
  stylix.targets.alacritty.enable = true;
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
    };
  };
}
