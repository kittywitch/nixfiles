{ config, ... }:

{
  programs.zsh = {
    shellAliases = {
      abbyradio = "mpv $(pass secrets/abbyradio)";
    };
  };
}
