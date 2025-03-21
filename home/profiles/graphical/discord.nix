{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.generators) toJSON;
in {
  home.packages = with pkgs; [
    (discord-krisp.override {
      withOpenASAR = true;
      withVencord = true; # can do this here too
    })
    vesktop
    #betterdiscordctl
  ];
  xdg.configFile."discord/settings.json".text = toJSON {} {
    "SKIP_HOST_UPDATE" = true;
  };
}
