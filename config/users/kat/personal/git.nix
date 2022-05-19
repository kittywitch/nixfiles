{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git-crypt
    gitAndTools.gitRemoteGcrypt
    git-revise
  ];
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
  };
}
