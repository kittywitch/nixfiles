{pkgs, ...}: {
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
  };
  home.packages = [pkgs.taskwarrior-tui];
}
