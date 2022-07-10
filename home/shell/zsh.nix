{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    # programs.zsh.enableAutosuggestions only includes nix-zsh-autocompletions
    zsh-completions
  ];

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    initExtra =
      let
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
        ]; in
      ''
	${if lib.hasSuffix "darwin" pkgs.stdenv.system then ''
        eval $(dircolors)
	'' else ''
	''}
        PROMPT_EOL_MARK='''
        ZSH_TAB_TITLE_ADDITIONAL_TERMS='kitty'
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
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1lb --color=always $realpath'
        ${lib.concatStringsSep "\n" (map (opt: "setopt ${opt}") zshOpts)}
        bindkey '^ ' autosuggest-accept
      '';
      shellAliases = lib.mkMerge [
      {
        nixdirfmt = "nixpkgs-fmt $(fd -e nix)";
        dmesg = "dmesg -HP";
        hg = "history 0 | rg";
      }
      (lib.mkIf (lib.hasSuffix "linux" pkgs.stdenv.system) {
        sys = "systemctl";
        sysu = "systemctl --user";
        walls = "journalctl _SYSTEMD_INVOCATION_ID=$(systemctl show -p InvocationID --value konawall.service --user) -o json | jq -r '.MESSAGE'";
        logu = "journalctl --user";
        log = "journalctl";
        lg = "log --no-pager | rg";
      })
    ];
    localVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=3,bold";
      ZSH_AUTOSUGGEST_USE_ASYNC = 1;
    };
    plugins = with pkgs.zsh-plugins; (map (plugin: plugin.zshPlugin) [
      tab-title
      vim-mode
      evil-registers
    ]);
  };

  home.sessionVariables = {
    XDG_DATA_HOME = "${config.xdg.dataHome}";
  };
}
