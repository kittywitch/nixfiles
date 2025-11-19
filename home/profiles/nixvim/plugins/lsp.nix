{lib, ...}: let
  inherit (lib.attrsets) genAttrs;
in {
  lsp.servers = let
    baseServer = {
      enable = true;
      activate = true;
    };
    serversToGen = [
      "rust_analyzer"
      "nixd"
      "zk"
    ];
  in
    (genAttrs serversToGen (_: baseServer))
    // {
    };
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
