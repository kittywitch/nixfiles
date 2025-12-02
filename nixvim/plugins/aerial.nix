_: {
  plugins = let
    basePlugin = {
      enable = true;
      autoLoad = true;
    };
  in {
    aerial =
      basePlugin
      // {
        settings = {
          backends = [
            "treesitter"
            "lsp"
            "markdown"
            "man"
          ];
          attach_mode = "global";
          highlight_on_hover = true;
          on_attach.__raw = ''
            function(buffer)
              vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
              vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
            end
          '';
        };
      };
  };
}
