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
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "workbench.colorTheme" = "Quiet Light";
      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
      };
      "alejandra.program" = "${pkgs.alejandra}/bin/alejandra";
      "editor.fontFamily" = ''"Iosevka", "Font Awesome 6 Free", "Font Awesome 6 Brands"'';
      "editor.fontLigatures" = true;
    };
  };
}
