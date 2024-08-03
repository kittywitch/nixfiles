{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) toJSON;
in {
  home.packages = with pkgs; [
    discord
  ];
  xdg.configFile."discord/settings.json".text = toJSON {} {
    "SKIP_HOST_UPDATE" = true;
  };
}
