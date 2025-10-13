_: {
  programs.wofi = {
    enable = false;
    settings = {
      insensitive = true;
      allow_images = true;
      hide_scroll = true;
      mode = "dmenu";
      prompt = "";
    };
  };
}
