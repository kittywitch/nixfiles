{ config, lib, pkgs, nixos, ... }: with lib;

let initvim = pkgs.callPackage
  ({ stdenv, nodejs }: stdenv.mkDerivation {
    name = "init.vim";
    src = ./init.vim;
    inherit nodejs;
    buildInputs = [
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
  home.sessionVariables = mkIf config.programs.neovim.enable { EDITOR = "nvim"; };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      source ${initvim}
      ${if nixos.networking.hostName == "koishi" then "color-scheme base16-default-light" else "colorscheme base16-default-dark"}
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
    ];
  };
}
