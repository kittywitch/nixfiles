{ config, lib, pkgs, ... }:

with lib;

{
  programs.zsh.shellAliases = {
    tt = "tmux new -AD -s";
  };
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    baseIndex = 1;
    extraConfig = with mapAttrs (_: v: "colour${toString v}") pkgs.base16.shell.shell256; ''
            # proper title handling
            set -g set-titles on
            set -g set-titles-string "#T"
            set -ga terminal-overrides ",xterm-256color:Tc"

            #  modes
            setw -g clock-mode-colour colour8
            setw -g mode-style 'fg=${base07} bg=${base02} bold'

            # panes
            set -g pane-border-style 'fg=${base06} bg=${base02}'
            set -g pane-active-border-style 'bg=${base0D} fg=${base07}'

            # statusbar
            set -g status-position bottom
            set -g status-justify left
            set -g status-style 'bg=${base00} fg=${base06}'
            set -g status-left '#[fg=${base06} bg=${base01}] #S@#h '
            set -g status-right '#[fg=${base07},bg=${base01}] %F #[fg=${base07},bg=${base02}] %H:%M:%S %Z '
            set -g status-right-length 50
            set -g status-left-length 20

            setw -g window-status-current-style 'fg=${base07} bg=${base0D} bold'
            setw -g window-status-current-format ' #I#[fg=${base07}]:#[fg=${base07}]#W#[fg=${base07}]#F '

            setw -g window-status-style 'fg=${base06} bg=${base03}'
            setw -g window-status-format ' #I#[fg=${base07}]:#[fg=${base06}]#W#[${base06}]#F '

            setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'

            # messages
            set -g message-style 'fg=colour232 bg=colour16 bold'

            # mouse
            set -g mouse on
    '';
  };
}
