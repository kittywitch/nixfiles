{
  config,
  lib,
  std,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (std) string set;
  initLua = pkgs.substituteAll ({
      name = "init.lua";
      src = ./init.lua;
      base16ShellPath = config.base16.shell.package;
      inherit (config.base16) defaultSchemeName;
      defaultSchemeSlug = config.base16.defaultScheme.slug;
    }
    // set.map (_: col: string.justifyRight 2 "0" (builtins.toString col.ansiIndex))
    (set.filter (var: _: string.hasInfix "base" var) config.base16.defaultScheme));
in {
  home.sessionVariables = mkIf config.programs.neovim.enable {EDITOR = "nvim";};

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Base16 manual
      config.base16.vim.plugin
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
      #				neorg
      # base16
      config.base16.vim.plugin
      # Fonts
      nvim-web-devicons
      # Completion
      nvim-cmp
      # Fuzzy Finder
      telescope-nvim
      # Buffers
      bufferline-nvim
      # Language Server
      nvim-lspconfig
      # tree
      nui-nvim
      neo-tree-nvim
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
      # For nvim-lspconfig, Terraform Language Server
      terraform-ls
      # For tree-sitter
      tree-sitter
      nodejs
      clang
      clangStdenv.cc
    ];
  };
  xdg.configFile."nvim/init.lua".source = initLua;
}
