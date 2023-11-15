{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = "kde";
    style = {
      name = "arc";
      package = pkgs.arc-kde-theme;
    };
  };
}
