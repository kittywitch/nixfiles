{
  pkgs,
  tree,
  ...
}: {
  programs.rbw = {
    enable = false;
    package = pkgs.rbw-bitw;
    settings = {
      inherit (tree.home.user.data) email;
      base_url = "https://vault.kittywit.ch";
      identity_url = null;
      lock_timeout = 3600;
    };
  };
}
