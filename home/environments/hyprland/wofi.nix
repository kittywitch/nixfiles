_: {
  programs.wofi = {
    enable = true;
    settings = {
      insensitive = true;
      allow_images = true;
      hide_scroll = true;
      mode = "dmenu";
      prompt = "";
    };
  };
}
