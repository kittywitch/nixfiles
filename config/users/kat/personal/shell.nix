{ config, lib, ... }: with lib;

{
  programs.zsh = {
    shellAliases = genAttrs ["radio" "tv"] (attr: {
      "abby${attr}" = "mpv $(bitw get secrets/abby -f ${attr})";
    });
  };
}
