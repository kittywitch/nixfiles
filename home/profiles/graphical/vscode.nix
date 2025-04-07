{pkgs, ...}: {
  programs.vscode = {
    enable = false;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      catppuccin.catppuccin-vsc
      kamadorueda.alejandra
      mkhl.direnv
      hashicorp.terraform
      jnoortheen.nix-ide
      pkgs.outrun
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "workbench.colorTheme" = "Outrun Night";
      "editor.suggest.preview" = true;
      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
      };
      "files.eol" = "\n";
      "alejandra.program" = "${pkgs.alejandra}/bin/alejandra";
      "editor.fontFamily" = ''"Monaspace Krypton", "Font Awesome 6 Free", "Font Awesome 6 Brands"'';
      "editor.fontLigatures" = true;
      "terraform.experimentalFeatures.prefillRequiredFields" = true;
      "terraform.experimentalFeatures.validateOnSave" = true;
      "terraform.codelens.referenceCount" = true;
      "go.alternateTools" = {
        gopls = "${pkgs.gopls}/bin/gopls";
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
