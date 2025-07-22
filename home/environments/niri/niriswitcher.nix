_: {
  programs.niriswitcher = {
    enable = true;
    settings = {
      keys = {
        modifier = "Super";
        switch = {
          next = "Tab";
          prev = "Shift+Tab";
        };
      };
      center_on_focus = true;
      appearance = {
        system_theme = "dark";
        icon_size = 64;
      };
    };
  };
}
