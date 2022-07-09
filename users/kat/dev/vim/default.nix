{ config, pkgs, ... }:

{
  programs.neovim = {
    extraConfig = ''
      luafile ${./init.lua}
    '';
    extraPackages = with pkgs; [
      terraform-ls
    ];
    plugins = with pkgs.vimPlugins; [
      neorg
      nvim-cmp
      plenary-nvim
      nvim-base16
      telescope-nvim
      nvim-lspconfig
    ];
  };
}
