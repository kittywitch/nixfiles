{ config, lib, pkgs, nixos, ... }: with lib;

{
  home.sessionVariables = mkIf config.programs.neovim.enable { EDITOR = "nvim"; };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-cool
      vim-lastplace
      vim-hexokinase
      vim-nix
      fzf-vim
      vim-fugitive
      vim-startify
      vim-lastplace
      lualine-nvim
      hop-nvim
    ];
    extraConfig = ''
    	luafile ${./init.lua}
    '';
  };
}
