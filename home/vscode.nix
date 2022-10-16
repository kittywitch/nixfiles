{ config, lib, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
  };
  home.packages = with pkgs; [
    rnix-lsp
  ];
}
