{ config, lib, pkgs, ... }:

{
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    extraConfig = import ./vimrc.nix { inherit pkgs config; };
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      notmuch-vim
      rust-vim
      coc-nvim
      coc-rust-analyzer
      coc-yank
      coc-python
      coc-json
      coc-fzf
      fzf-vim
      coc-yaml
      coc-git
      coc-css
      coc-html
      vim-fugitive
      vim-startify
      vim-airline
      vim-airline-themes
      vim-lastplace
      base16-vim
    ];
    coc = {
      enable = true;
      settings = {
        "rust.rustfmt_path" = "${pkgs.rustfmt}/bin/rustfmt";
        "rust-analyzer.serverPath" = "rust-analyzer";
        "rust-analyzer.updates.prompt" = false;
        "rust-analyzer.notifications.cargoTomlNotFound" = false;
        "rust-analyzer.notifications.workspaceLoaded" = false;
        "rust-analyzer.procMacro.enable" = true;
        "rust-analyzer.cargo.loadOutDirsFromCheck" = true;
        "rust-analyzer.cargo-watch.enable" = true;
        "rust-analyzer.completion.addCallParenthesis" = false; # consider using this?
        "rust-analyzer.hoverActions.linksInHover" = true;
        "rust-analyzer.diagnostics.disabled" = [
          "inactive-code" # it has strange cfg support..?
        ];
      };
    };
  };
}
