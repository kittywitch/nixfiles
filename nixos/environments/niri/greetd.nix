{pkgs, ...}: {
  programs.regreet = {
    enable = true;
  };
  stylix.targets.regreet.enable = true;
  services.greetd = {
    enable = true;
  };
}
