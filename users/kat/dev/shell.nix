{ config, ... }:

{
  programs.zsh.shellAliases = {
    readmefmt = "pandoc -f markdown -t gfm --reference-links ./readme.md --output readme.md --wrap=preserve";
  };
}
