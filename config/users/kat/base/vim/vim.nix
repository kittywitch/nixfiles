{ config, lib, pkgs, ... }: with lib;

let initvim = pkgs.callPackage
  ({ stdenv }: stdenv.mkDerivation {
    name = "init.vim";
    src = ./init.vim;
    phases = [ "buildPhase" ];
    buildPhase = ''
      substituteAll $src $out
    '';
  })
  { };
in
{
  home.sessionVariables = mkIf config.programs.vim.enable { EDITOR = "vim"; };

  programs.vim = {
    enable = false;
    packageConfigurable = pkgs.vim_configurable-pynvim;
    extraConfig = ''
      source ${initvim}
      ${if nixos.networking.hostName == "koishi" then "color-scheme base16-default-light" else "colorscheme base16-default-dark"}
    '';
    plugins = with pkgs.vimPlugins; [
      "vim-cool"
      "vim-lastplace"
      "vim-hexokinase"
      "vim-easymotion"
      "vim-nix"
      "fzf-vim"
      "vim-fugitive"
      "vim-startify"
      "vim-airline"
      "vim-airline-themes"
      "vim-lastplace"
      "base16-vim"
    ];
  };
}
