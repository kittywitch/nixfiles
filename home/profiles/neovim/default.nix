{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  initLua = pkgs.replaceVars ./init.lua {
    inity = config.programs.neovim.generatedConfigs.lua;
  };
in {
  stylix.targets.neovim = {
    enable = true;
    transparentBackground = {
      main = true;
      signColumn = true;
      numberLine = true;
    };
  };
  home.sessionVariables = mkIf config.programs.neovim.enable {EDITOR = "nvim";};
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
      cmp-git
      cmp-nvim-lsp
      # Fuzzy Finder
      telescope-nvim
      # Buffers
      bufferline-nvim
      rustaceanvim
      # tree
      nui-nvim
      neo-tree-nvim
      # obsidian vault support for neovim
      obsidian-nvim
      # commentry
      vim-commentary
      # tree sitter
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (_:
        with pkgs.tree-sitter-grammars; [
          tree-sitter-c
          tree-sitter-lua
          tree-sitter-rust
          #tree-sitter-bash
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
      rainbow-delimiters-nvim
      nvim-treesitter-context
      twilight-nvim
    ];
    extraPackages = with pkgs; [
      # For tree-sitter
      tree-sitter
      nodejs
      clang
      clangStdenv.cc
    ];
  };
  xdg.configFile = {
    "nvim/init.lua".source = initLua;
    "nvim/after/ftplugin/rust.lua".source = ./rust.lua;
  };
}
