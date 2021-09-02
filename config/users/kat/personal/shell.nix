{ config, lib, pkgs, ... }: with lib;

{
  home.shell.functions = {
    nano = ''
      ${pkgs.kitty}/bin/kitty +kitten icat ${./nano.png}
    '';
  };
  programs.zsh = {
    shellAliases = mapListToAttrs (attr: nameValuePair "abby${attr}" "mpv $(bitw get secrets/abby -f ${attr})") ["radio" "tv"];
  };
}
