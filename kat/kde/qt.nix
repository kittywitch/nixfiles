{ pkgs, ... }: {
  qt = {
    enable = true;
    platformTheme = "kde";
    style = {
      name = "Arc";
      package = pkgs.arc-kde-theme;
    };
  };
}
