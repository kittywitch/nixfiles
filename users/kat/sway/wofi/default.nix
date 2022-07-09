{ config, kw, ... }:

{
  xdg.configFile."wofi/wofi.css" = { inherit (kw.sassTemplate { name = "wofi-style"; src = ./wofi.sass; }) source; };
}
