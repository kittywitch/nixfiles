{
  config,
  lib,
  std,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkMerge mkIf;
  inherit (std) string list;
in {
  home.packages = with pkgs; [
    # programs.zsh.enableAutosuggestions only includes nix-zsh-autocompletions
    zsh-completions
  ];

  #xdg.configFile."kattheme_immutable.json".text = serde.toJSON rec {
  #default = config.base16.defaultSchemeName;
  #current = default;
  #};

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initContent = let
      zshOpts = [
        "auto_pushd"
        "pushd_ignore_dups"
        "pushdminus"
        "rmstarsilent"
        "nonomatch"
        "long_list_jobs"
        "interactivecomments"
        "append_history"
        "hist_ignore_space"
        "hist_verify"
        "inc_append_history"
        "nosharehistory"
        "nomenu_complete"
        "auto_menu"
        "no_auto_remove_slash"
        "complete_in_word"
        "always_to_end"
        "nolistbeep"
        "autolist"
        "listrowsfirst"
      ];
    in ''
        ${
        if pkgs.hostPlatform.isLinux
        then ''
          eval $(dircolors -b | sd "\*#=00;90" "*\#=00;90")
        ''
        else ''
        ''
      }
      PROMPT_EOL_MARK='''
        ZSH_TAB_TITLE_ADDITIONAL_TERMS='alacritty'
        ZSH_TAB_TITLE_ENABLE_FULL_COMMAND=true
        zmodload -i zsh/complist
        h=()
        if [[ -r ~/.ssh/config ]]; then
          h=($h ''${''${''${(@M)''${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
            fi
            if [[ $#h -gt 0 ]]; then
              zstyle ':completion:*:ssh:*' hosts $h
                zstyle ':completion:*:slogin:*' hosts $h
                fi
                unset h
                u=(root ${config.home.username})
                zstyle ':completion:*:ssh:*' users $u
                unset u
                zstyle ':completion:*:*:*:*:*' menu select
                zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
                zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
                zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
                zstyle ':completion:*:complete:pass:*:*' matcher 'r:|[./_-]=** r:|=*' 'l:|=* r:|=*'
                zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1lb --color=always $realpath'
        ${string.concatSep "\n" (map (opt: "setopt ${opt}") zshOpts)}
      bindkey '^ ' autosuggest-accept
        ${
        if pkgs.hostPlatform.isDarwin
        then ''
          export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        ''
        else ""
      }
    '';
    shellAliases = mkMerge [
      {
        cat = "bat";
        top = "btm";
        dmesg = "dmesg -HP";
        hg = "history 0 | rg";
      }
      (mkIf pkgs.hostPlatform.isLinux {
        sys = "systemctl";
        sysu = "systemctl --user";
        logu = "journalctl --user";
        log = "journalctl";
        lg = "log --no-pager | rg";
      })
    ];
    localVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=3,bold";
      ZSH_AUTOSUGGEST_USE_ASYNC = 1;
    };
    plugins = with inputs.arcexprs.legacyPackages.${pkgs.system}.zsh-plugins; (list.map (plugin: plugin.zshPlugin) [
      tab-title
      vim-mode
      evil-registers
    ]);
  };

  home.sessionVariables = {
    XDG_DATA_HOME = "${config.xdg.dataHome}";
  };
}
