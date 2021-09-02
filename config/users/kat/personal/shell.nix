{ config, lib, ... }: with lib;

{
  programs.zsh = {
    shellAliases = mapListToAttrs (attr: nameValuePair "abby${attr}" "mpv $(bitw get secrets/abby -f ${attr})") ["radio" "tv"];
  };
}
