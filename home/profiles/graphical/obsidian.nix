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
      appearance = {
        monospaceFontFamily =  "Iosevka,Consolas";
        textFontFamily = "Ubuntu Sans";
        interfaceFontFamily = "Monaspace Krypton";
        baseFontSize = 16;
      };
    };
  };
}
