{
  std,
  inputs,
  ...
}: let
  inherit (std) set list;
in {
  programs.zsh.shellAliases = {
    tt = "tmux new -AD -s";
  };
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    baseIndex = 1;
    extraConfig = with set.map (_: v: "colour${builtins.toString (list.unsafeHead v)}") inputs.base16.lib.base16.shell.mapping256; ''
      # proper title handling
      set -g set-titles on
      set -g set-titles-string "#T"
      set -ga terminal-overrides ",xterm-256color:Tc"

      # mouse
      set -g mouse on
    '';
  };
}
