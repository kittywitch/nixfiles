{
  config,
  pkgs,
  lib,
  tree,
  ...
}: let
  inherit (lib.meta) getExe';
in {
  home.packages = with pkgs; [
    git-remote-gcrypt
    git-crypt
    git-revise
    radicle-tui
  ];

  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = with tree.home.user.data; {
          name = userName;
          email = userEmail;
        };
      };
    };
    jjui = {
      enable = true;
    };
    delta = {
      enable = true;
    };
    git = {
      inherit (tree.home.user.data) userName userEmail;
      package = pkgs.gitFull;
      enable = true;
      settings = {
        core = {
        };
        init = {defaultBranch = "main";};
        protocol.gcrypt.allow = "always";
        merge.conflictstyle = "diff3";
        annex = {
          autocommit = false;
          backend = "BLAKE2B512";
          synccontent = true;
        };
      };
      signing = {
        inherit (tree.home.user.data) key;
        signByDefault = true;
      };
    };
  };
}
