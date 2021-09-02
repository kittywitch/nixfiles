{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git-crypt
    gitAndTools.gitRemoteGcrypt
    gitAndTools.gitAnnex
    git-revise
    gitAndTools.git-annex-remote-b2
  ];
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
  };
}
