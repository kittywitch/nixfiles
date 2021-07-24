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
in {
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
  home.packages = with pkgs; [ fzf fd akiflags ];
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = ''
        echo ""; akiflags -rb;
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
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "adb" "cargo" "emoji" ];
    };
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
