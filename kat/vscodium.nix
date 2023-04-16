{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      kamadorueda.alejandra
      mkhl.direnv
      mhutchie.git-graph
      golang.go
      hashicorp.terraform
      arrterian.nix-env-selector
      jnoortheen.nix-ide
      vscodevim.vim
      catppuccin.catppuccin-vsc
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "workbench.colorTheme" = "Catppuccin Frappé";
      "editor.suggest.preview" = true;
      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
      };
      "alejandra.program" = "${pkgs.alejandra}/bin/alejandra";
      "editor.fontFamily" = ''"Iosevka", "Font Awesome 6 Free", "Font Awesome 6 Brands"'';
      "editor.fontLigatures" = true;
      "terraform.experimentalFeatures.prefillRequiredFields" = true;
      "terraform.experimentalFeatures.validateOnSave" = true;
      "terraform.codelens.referenceCount" = true;
      "go.alternateTools" = {
        gopls = "/nix/store/ma4bapwwd54v6sl93w9c80fhw1ynvric-gopls-0.11.0/bin/gopls";
      };
      "vim.useSystemClipboard" = true;
      go = {
        inlayHints = {
          assignVariableTypes = true;
          compositeLiteralFields = true;
          compositeLiteralTypes = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
      };
    };
  };
}
