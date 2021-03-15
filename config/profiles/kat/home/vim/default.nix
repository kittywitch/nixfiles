{ config, lib, pkgs, witch, ... }:

{
  config = lib.mkIf config.deploy.profile.kat {
    home.sessionVariables.EDITOR = "vim";
    programs.vim = {
      enable = true;
      package = pkgs.arc.pkgs.vim_configurable-pynvim;
      #withPython3 = true;
      plugins = with pkgs.vimPlugins; [
        nerdtree
        vim-nix
        coc-nvim
        coc-yank
        coc-python
        coc-json
        coc-yaml
        coc-git
        vim-fugitive
        vim-startify
        base16-vim 
      ];
      #extraPackages = with pkgs;
      #  [ (python3.withPackages (ps: with ps; [ black flake8 ])) ];
      #extraPython3Packages = (ps: with ps; [ jedi pylint ]);
      extraConfig = import ./vimrc.nix { inherit pkgs config; };
    };
    xdg.dataFile = {
      "vim/undo/.keep".text = "";
      "vim/swap/.keep".text = "";
      "vim/backup/.keep".text = "";
    };
    xdg.configFile = {
      "vim/coc-settings.json".text = builtins.readFile ./coc-settings.json;
    };
  };
}
