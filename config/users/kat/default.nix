{ config, pkgs, ... }:

{
  imports = [
    ./ssh.nix
    ./desktop.nix
    ./gaming.nix
    ./network.nix
    ./sway.nix
    ./kitty.nix
    ./emacs.nix
  ];

  users.users.kat = {
    uid = 1000;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCocjQqiDIvzq+Qu3jkf7FXw5piwtvZ1Mihw9cVjdVcsra3U2c9WYtYrA3rS50N3p00oUqQm9z1KUrvHzdE+03ZCrvaGdrtYVsaeoCuuvw7qxTQRbItTAEsfRcZLQ5c1v/57HNYNEsjVrt8VukMPRXWgl+lmzh37dd9w45cCY1QPi+JXQQ/4i9Vc3aWSe4X6PHOEMSBHxepnxm5VNHm4PObGcVbjBf0OkunMeztd1YYA9sEPyEK3b8IHxDl34e5t6NDLCIDz0N/UgzCxSxoz+YJ0feQuZtud/YLkuQcMxW2dSGvnJ0nYy7SA5DkW1oqcy6CGDndHl5StOlJ1IF9aGh0gGkx5SRrV7HOGvapR60RphKrR5zQbFFka99kvSQgOZqSB3CGDEQGHv8dXKXIFlzX78jjWDOBT67vA/M9BK9FS2iNnBF5x6shJ9SU5IK4ySxq8qvN7Us8emkN3pyO8yqgsSOzzJT1JmWUAx0tZWG/BwKcFBHfceAPQl6pwxx28TM3BTBRYdzPJLTkAy48y6iXW6UYdfAPlShy79IYjQtEThTuIiEzdzgYdros0x3PDniuAP0KOKMgbikr0gRa6zahPjf0qqBnHeLB6nHAfaVzI0aNbhOg2bdOueE1FX0x48sjKqjOpjlIfq4WeZp9REr2YHEsoLFOBfgId5P3BPtpBQ== cardno:000612078454"
    ];
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.kat = {
    programs.fish = {
      enable = true;
      shellAliases = { nixdirfmt = "fd --color=never .nix | xargs nixfmt"; };
      plugins = [{
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "d63054b24c2f63aaa3a08fb9ec9d0da4c70ab922";
          sha256 = "0pwci5xxm8308nrb52s5nyxijk0svar8nqrdfvkk2y34z1cg319b";
        };
      }];
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.git = {
      enable = true;
      userName = "kat witch";
      userEmail = "kat@kittywit.ch";
      signing = {
        key = "01F50A29D4AA91175A11BDB17248991EFA8EFBEE";
        signByDefault = true;
      };
    };

    programs.bat.enable = true;
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
              '';
    };
  };
}
