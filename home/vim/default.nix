{ config, lib, pkgs, nixos, ... }:

let
  inherit (lib.modules) mkIf;
in {
  home.sessionVariables = mkIf config.programs.neovim.enable { EDITOR = "nvim"; };

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
      # Fonts
      nvim-web-devicons
      # Completion
      nvim-cmp
      # base16
      nvim-base16
      # Fuzzy Finder
      telescope-nvim
      # Buffers
      bufferline-nvim
      # Language Server
      nvim-lspconfig
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with pkgs.tree-sitter-grammars; [
        tree-sitter-c
        tree-sitter-lua
        tree-sitter-rust
        tree-sitter-bash
        tree-sitter-css
        tree-sitter-dockerfile
        tree-sitter-go
        tree-sitter-hcl
        tree-sitter-html
        tree-sitter-javascript
        tree-sitter-markdown
        tree-sitter-nix
        tree-sitter-norg
        tree-sitter-python
        tree-sitter-regex
        tree-sitter-scss
      ]))
      # Treesitter Plugins
      nvim-ts-rainbow
      nvim-treesitter-context
      twilight-nvim
      # Languages
      vim-nix
      vim-terraform
    ];
    extraPackages = with pkgs; [
      # For nvim-lspconfig, Terraform Language Server
      terraform-ls
      # For tree-sitter
      tree-sitter
      nodejs
      clang
      clangStdenv.cc
    ];
    extraConfig = ''
    luafile ${./init.lua}
    '';
  };
}
