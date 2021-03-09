{ config, lib, pkgs, witch, ... }:

{
  config = lib.mkIf config.deploy.profile.kat {
    home.sessionVariables.EDITOR = "nvim";
    programs.neovim = {
      enable = true;
      withPython3 = true;
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
        {
          plugin = vim-startify;
          config = "let g:startify_change_to_vcs_root = 0";
        }
      ];
      extraPackages = with pkgs;
        [ (python3.withPackages (ps: with ps; [ black flake8])) ];
      extraPython3Packages = (ps: with ps; [ jedi pylint ]);
      extraConfig = import ./vimrc.nix { inherit pkgs; };
    };
    xdg.configFile."nvim/coc-settings.json".text =
      builtins.readFile ./coc-settings.json;
  };
}
