_: {
  programs.obsidian = {
    enable = true;

    vaults."Notes".enable = true;

    defaultSettings = {
      app = {
        vimMode = true;
        showUnsupportedFiles = true;
        showLineNumber = true;
        livePreview = false;
        readableLineLength = true;
      };
    };
  };
}
