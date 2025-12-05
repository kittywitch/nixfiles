{
  lib,
  std,
  pkgs,
  ...
}: let
  inherit (std) set;
  inherit (lib.attrsets) genAttrs;
in {
  lsp.servers = let
    baseServer = {
      enable = true;
      activate = true;
    };
    disablePackage = {
      package = null;
    };
    serversToGen = [
      "rust_analyzer"
      "nixd"
      "zk"
      "gleam"
      "qmlls"
      "luau_lsp"
      "stylua"
    ];
    disabledPackageServers = [
      "rust_analyzer"
      "luau_lsp"
      "stylua"
    ];
  in
    set.merge [
      (genAttrs serversToGen (_: baseServer))
      (genAttrs disabledPackageServers (_: disablePackage))
      {
        qmlls.config = {
          cmd = "-E";
        };
      }
    ];
  plugins = let
    pluginsToGen = [
      "lspconfig"
      "treesitter"
      "cmp"
      "cmp-clippy"
      "cmp-cmdline"
      "cmp-emoji"
      "cmp-nvim-lsp"
      "cmp-path"
      "cmp-rg"
      "cmp-spell"
      "cmp-tmux"
      "cmp-treesitter"
      "cmp-zsh"
    ];
    basePlugin = {
      enable = true;
      autoLoad = true;
    };
  in
    set.merge [
      (genAttrs pluginsToGen (_: basePlugin))
      {
        treesitter = {
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            json
            make
            markdown
            regex
            toml
            xml
            yaml
            gleam
            nix
          ];
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };
      }
    ];
  diagnostic.settings = {
    virtual_text = true;
    virtual_lines = true;
    underlines = true;
  };
}
