{
  pkgs,
  tree,
  ...
}: {
  programs.rbw = {
    enable = true;
    package = pkgs.rbw-bitw;
    settings = {
      inherit (import tree.kat.user.data) email;
      base_url = "https://vault.kittywit.ch";
      identity_url = null;
      lock_timeout = 3600;
    };
  };
}
