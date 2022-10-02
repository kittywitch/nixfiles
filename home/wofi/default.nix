{ config, nixfiles, ... }:

{
  xdg.configFile."wofi/wofi.css" = { inherit (nixfiles.sassTemplate { name = "wofi-style"; src = ./wofi.sass; }) source; };
}
