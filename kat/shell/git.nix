{
  pkgs,
  tree,
  ...
}: {
  home.packages = with pkgs; [
    gitAndTools.git-remote-gcrypt
    git-crypt
    git-revise
  ];

  programs.git = {
    inherit (tree.kat.user.data) userName userEmail;
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    extraConfig = {
      init = {defaultBranch = "main";};
      protocol.gcrypt.allow = "always";
      annex = {
        autocommit = false;
        backend = "BLAKE2B512";
        synccontent = true;
      };
    };
    signing = {
      inherit (tree.kat.user.data) key;
      signByDefault = true;
    };
  };
}
