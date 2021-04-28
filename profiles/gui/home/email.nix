{ config, lib, pkgs, ... }:

{
  programs.notmuch = {
    enable = true;
    hooks = { preNew = "mbsync --all"; };
  };
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  accounts.email = { maildirBasePath = "${config.home.homeDirectory}/mail"; };
  programs.vim.plugins = [ pkgs.arc.pkgs.vimPlugins.notmuch-vim ];
}
