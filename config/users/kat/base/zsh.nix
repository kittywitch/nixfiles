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
      ${pkgs.wezterm}/bin/wezterm imgcat ${./nano.png}
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
            zmodload -i zsh/complist
            zstyle ':completion:*' list-colors ""
            zstyle ':completion:*:*:*:*:*' menu select
            zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
            zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
            zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
            zstyle ':completion:*:complete:pass:*:*' matcher 'r:|[./_-]=** r:|=*' 'l:|=* r:|=*'
                ${lib.concatStringsSep "\n" (map (opt: "setopt ${opt}") zshOpts)}
          bindkey '^ ' autosuggest-accept
      '';
    shellAliases = {
      nixdirfmt = "fd --color=never .nix | xargs nixpkgs-fmt";
      exa = "exa --time-style long-iso";
      ls = "exa -G";
      la = "exa -Ga";
      ll = "exa -l";
      lla = "exa -lga";
      sys = "systemctl";
      log = "journalctl";
      dmesg = "dmesg -HP";
      lg = "log --no-pager | grep";
      hg = "history 0 | grep";
    };
    localVariables = {
      _Z_DATA = "${config.xdg.dataHome}/z/data";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=3,bold";
      ZSH_AUTOSUGGEST_USE_ASYNC = 1;
    };
    plugins = [
      (with pkgs.zsh-syntax-highlighting; {
        name = "zsh-syntax-highlighting";
        inherit src;
      })
      (with pkgs.zsh-plugins.vim-mode; {
        name = "zsh-vim-mode";
        inherit src;
      })
      (with pkgs.zsh-plugins.evil-registers; {
        name = "evil-registers";
        inherit src;
      })
      {
        name = "z";
        file = "z.sh";
        src = pkgs.fetchFromGitHub {
          owner = "rupa";
          repo = "z";
          rev = "9d5a3fe0407101e2443499e4b95bca33f7a9a9ca";
          sha256 = "0aghw6zmd3851xpzgy0jkh25wzs9a255gxlbdr3zw81948qd9wb1";
        };
      }
      {
        name = "fzf-z";
        src = pkgs.fetchFromGitHub {
          owner = "andrewferrier";
          repo = "fzf-z";
          rev = "089ba6cacd3876c349cfb6b65dc2c3e68b478fd0";
          sha256 = "1lvvkz0v4xibq6z3y8lgfkl9ibcx0spr4qzni0n925ar38s20q81";
        };
      }
    ];
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
