{
  lib,
  std,
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
      }
    ];
  plugins = let
    pluginsToGen = [
      "lspconfig"
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
    genAttrs pluginsToGen (_: basePlugin);
  diagnostic.settings = {
    virtual_text = true;
    virtual_lines = true;
    underlines = true;
  };
}
