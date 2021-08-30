{ config, lib, pkgs, ... }:

with lib;

let
  shellFunAlias = command: replacement: ''
    if [[ ! -t 0 ]]; then
      command ${command} $@
    else
      echo 'use ${replacement}!'
    fi
  '';
  shellFunAliases = mapAttrs shellFunAlias;
in
{
  home.shell.functions = {
    genmac = ''
      nix run nixpkgs.openssl -c openssl rand -hex 6 | sed 's/\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)/\1:\2:\3:\4:\5:\6/'
    '';
    nano = ''
      ${pkgs.kitty}/bin/kitty +kitten icat ${./nano.png}
    '';
  } // shellFunAliases {
    sed = "sd";
    find = "fd";
    grep = "rg";
  };
  xdg.dataFile = { "z/.keep".text = ""; };
  home.packages = with pkgs; [ fzf fd zsh-completions akiflags ];
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
        ZSH_TAB_TITLE_ADDITIONAL_TERMS='foot'
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
    shellAliases = {
      nixdirfmt = "nixpkgs-fmt $(fd -e nix)";
      exa = "exa --time-style long-iso";
      ls = "exa -G";
      la = "exa -Ga";
      ll = "exa -l";
      lla = "exa -lga";
      sys = "systemctl";
      sysu = "systemctl --user";
      walls = "journalctl _SYSTEMD_INVOCATION_ID=$(systemctl show -p InvocationID --value konawall.service --user) -o json | jq -r '.MESSAGE'";
      logu = "journalctl --user";
      log = "journalctl";
      dmesg = "dmesg -HP";
      lg = "log --no-pager | rg";
      hg = "history 0 | rg";
    };
    localVariables = {
      _Z_DATA = "${config.xdg.dataHome}/z/data";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=3,bold";
      ZSH_AUTOSUGGEST_USE_ASYNC = 1;
    };
    plugins = with pkgs.zsh-plugins; (map (plugin: plugin.zshPlugin) [
      tab-title
      vim-mode
      evil-registers
    ]) ++ (map
      (plugin: (with pkgs.${plugin}; {
        name = pname;
        inherit src;
      })) [
      "zsh-z"
    ]) ++ [
      (with pkgs.zsh-fzf-tab; {
        name = "fzf-tab";
        inherit src;
      })
    ];
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
