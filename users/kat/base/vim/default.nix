{ config, lib, pkgs, nixos, ... }: with lib;

{
  home.sessionVariables = mkIf config.programs.neovim.enable { EDITOR = "nvim"; };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Disables and re-enables highlighting when searching
      vim-cool
      # Colour highlighting
      vim-hexokinase
      # fzf
      fzf-vim
      # Git porcelain
      vim-fugitive
      # Start screen
      vim-startify
      # Re-open with cursor at the same place
      vim-lastplace
      # Status Bar
      lualine-nvim
      # EasyMotion Equivalent
      hop-nvim
      # Languages
      vim-nix
      vim-terraform
    ];
    extraConfig = ''
    	luafile ${./init.lua}
    '';
  };
}
