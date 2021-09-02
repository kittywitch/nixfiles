{ config, ... }:

{
  programs.zsh.shellAliases = {
    readmefmt = "pandoc -f markdown -t gfm --reference-links ./README.md --output README.md --wrap=preserve";
  };
}
