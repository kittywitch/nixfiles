{ config, pkgs, ... }:

{
  xdg.configFile."wofi/wofi.css".source = pkgs.wofi-style { inherit (config.kw.theme) base16; };
}
