{ config, ... }:

{
  xdg.configFile."inputrc".text = ''
    set editing-mode vi
    set keyseq-timeout 1
    set mark-symlinked-directories on
    set completion-prefix-display-length 8
    set show-all-if-ambiguous on
    set show-all-if-unmodified on
    set visible-stats on
    set colored-stats on
    set bell-style audible
    set meta-flag on
    set input-meta on
    set convert-meta off
    set output-meta on
  '';

  home.sessionVariables.INPUTRC = "${config.xdg.configHome}/inputrc";
}
