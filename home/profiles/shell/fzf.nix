{
  pkgs,
  std,
  ...
}: let
  inherit (std) list;
in {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh.plugins = list.optional (pkgs.hostPlatform == pkgs.buildPlatform) {
    name = "fzf-tab";
    src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
  };
}
