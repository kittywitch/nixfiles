{ config, pkgs, ... }:

{
  programs.neovim = {
    extraConfig = ''
      ${source ./init.vim}
    '';
    plugins = with pkgs.vimPlugins; [
      notmuch-vim
    ];
  };
}
