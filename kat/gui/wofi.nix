{ kittywitch, ... }: {
  xdg.configFile."wofi/wofi.css" = { inherit (kittywitch.sassTemplate { name = "wofi-style"; src = ./wofi.sass; }) source; };
}
