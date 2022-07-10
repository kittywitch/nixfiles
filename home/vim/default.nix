{ config, lib, pkgs, nixos, ... }:

{
  home.sessionVariables = lib.mkIf config.programs.neovim.enable { EDITOR = "nvim"; };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Libraries
      plenary-nvim
      # Disables and re-enables highlighting when searching
      vim-cool
      # Colour highlighting
      vim-hexokinase
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
      # org-mode for vim
      neorg
      # Completion
      nvim-cmp
      # Fuzzy Finder
      telescope-nvim
      # Language Server
      nvim-lspconfig
      # Languages
      vim-nix
      vim-terraform
    ];
    extraPackages = with pkgs; [
      # For nvim-lspconfig, Terraform Language Server
      terraform-ls
    ];
    extraConfig = ''
    	luafile ${./init.lua}
    '';
  };
}
