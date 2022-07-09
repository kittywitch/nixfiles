{ config, pkgs, ... }:

{
  programs.neovim = {
    extraConfig = ''
      source ${./init.vim}
    '';
  };
}
