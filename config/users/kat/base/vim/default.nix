{ config, lib, pkgs, ... }:

let initvim = pkgs.callPackage
  ({ stdenv, elinks, nodejs }: stdenv.mkDerivation {
    name = "init.vim";
    src = ./init.vim;
    inherit nodejs elinks;
    buildInputs = [
      elinks
      nodejs
    ];
    phases = [ "buildPhase" ];
    buildPhase = ''
      substituteAll $src $out
    '';
  })
  { };
in
{
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    extraConfig = ''
      source ${initvim}
    '';
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-cool
      vim-lastplace
      vim-hexokinase
      vim-easymotion
      vim-nix
      fzf-vim
      vim-fugitive
      vim-startify
      vim-airline
      vim-airline-themes
      vim-lastplace
      base16-vim
    ];
  };
}
