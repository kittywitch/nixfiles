{ kittywitch, ... }: {
  programs.wofi = {
    enable = true;
    settings = {
      style = let
        template = kittywitch.sassTemplate { name = "wofi-style"; src = ./wofi.sass; };
      in template.source;
      insensitive = true;
      allow_images = true;
      hide_scroll = true;
      width = "25%";
      mode = "dmenu";
      prompt = "";
    };
  };
}
