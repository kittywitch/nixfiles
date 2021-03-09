{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.deploy.profile.kat {
    programs.fish.shellAliases = {
      tne = "tmux new -s";
      tat = "tmux attach -t";
      tren = "tmux new -AD -s";
    };
    programs.tmux = {
      enable = true;
      extraConfig = ''

        #  modes
        setw -g clock-mode-colour colour5
        setw -g mode-style 'fg=colour1 bg=colour18 bold'

        # panes
        set -g pane-border-style 'fg=colour19 bg=colour0'
        set -g pane-active-border-style 'bg=colour0 fg=colour9'

        # statusbar
        set -g status-position bottom
        set -g status-justify left
        set -g status-style 'bg=colour18 fg=colour137 dim'
        set -g status-left '''
        set -g status-right '#[fg=colour233,bg=colour19] %F #[fg=colour233,bg=colour8] %H:%M:%S %Z'
        set -g status-right-length 50
        set -g status-left-length 20

        setw -g window-status-current-style 'fg=colour1 bg=colour19 bold'
        setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '

        setw -g window-status-style 'fg=colour9 bg=colour18'
        setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

        setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'

        # messages
        set -g message-style 'fg=colour232 bg=colour16 bold'

        # mouse
        set -g mouse on
              '';
    };
  };
}
