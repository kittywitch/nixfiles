_: {
  keymaps = [
    {
      options.silent = true;
      key = "<Leader>fb";
      action.__raw = ''
        function()
          require("telescope").extensions.file_browser.file_browser()
        end
      '';
    }
  ];
  plugins = let
    basePlugin = {
      enable = true;
      autoLoad = true;
    };
  in {
    telescope =
      basePlugin
      // {
        keymaps = {
          "<Leader>fg" = "live_grep";
          "<Leader>ff" = "find_files";
          "<Leader>fB" = "buffers";
          "<Leader>fh" = "help_tags";
        };
        extensions = {
          file-browser.enable = true;
          frecency.enable = true;
          ui-select.enable = true;
          undo.enable = true;
        };
      };
  };
}
