{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    (discord-krisp.override {
      withOpenASAR = true;
      withMoonlight = true;
      withVencord = false; # can do this here too
    })
    legcord
    #dorion
    #betterdiscordctl
  ];

  programs.moonlight-mod = {
    enable = true;
  };
}
