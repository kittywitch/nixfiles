{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    gitAndTools.git-remote-gcrypt
    git-crypt
    git-revise
  ];

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Kat Inskip";
    userEmail = "kat@inskip.me";
    extraConfig = {
      init = { defaultBranch = "main"; };
      protocol.gcrypt.allow = "always";
      annex = {
        autocommit = false;
        backend = "BLAKE2B512";
        synccontent = true;
      };
    };
    signing = {
      key = "0xE8DDE3ED1C90F3A0";
      signByDefault = true;
    };
  };
}
