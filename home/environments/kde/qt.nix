{pkgs, ...}: {
  qt = {
    enable = false;
    platformTheme = "kde";
    style = {
      name = "arc";
      package = pkgs.arc-kde-theme;
    };
  };
}
