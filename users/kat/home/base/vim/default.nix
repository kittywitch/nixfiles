{ config, lib, pkgs, ... }:

{
  home.sessionVariables.EDITOR = "vim";
  programs.vim = {
    enable = true;
    package = pkgs.arc.pkgs.vim_configurable-pynvim;
    #withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      vim-nix
      rust-vim
      coc-nvim
      coc-rust-analyzer
      coc-yank
      coc-python
      coc-json
      coc-yaml
      coc-git
      coc-css
      coc-html
      vim-fugitive
      vim-startify
      vim-airline
      vim-airline-themes
      base16-vim
    ];
    #extraPackages = with pkgs;
    #  [ (python3.withPackages (ps: with ps; [ black flake8 ])) ];
    #extraPython3Packages = (ps: with ps; [ jedi pylint ]);
    extraConfig = import ./vimrc.nix { inherit pkgs config; };
  };
  xdg.dataFile = {
    "vim/undo/.keep".text = "";
    "vim/swap/.keep".text = "";
    "vim/backup/.keep".text = "";
  };
  xdg.configFile = {
    "vim/coc/coc-settings.json".text = builtins.toJSON {
      "rust.rustfmt_path" = "${pkgs.rustfmt}/bin/rustfmt";
      "rust-analyzer.serverPath" = "rust-analyzer";
      "rust-analyzer.updates.prompt" = false;
      "rust-analyzer.notifications.cargoTomlNotFound" = false;
      "rust-analyzer.notifications.workspaceLoaded" = false;
      "rust-analyzer.procMacro.enable" = true;
      "rust-analyzer.cargo.loadOutDirsFromCheck" = true;
      "rust-analyzer.cargo-watch.enable" =
        true; # TODO: want some way to toggle this on-demand?
      "rust-analyzer.completion.addCallParenthesis" =
        false; # consider using this?
      "rust-analyzer.hoverActions.linksInHover" = true;
      "rust-analyzer.diagnostics.disabled" = [
        "inactive-code" # it has strange cfg support..?
      ];
    };
  };
}
