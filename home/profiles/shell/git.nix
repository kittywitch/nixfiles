{
  pkgs,
  tree,
  ...
}: {
  home.packages = with pkgs; [
    gitAndTools.git-remote-gcrypt
    git-crypt
    git-revise
    radicle-tui
  ];

  programs = {
    jujutsu = {
      enable = true;
    };
    git = {
      inherit (tree.home.user.data) userName userEmail;
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      delta = {
        enable = true;
      };
      extraConfig = {
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
