{
  pkgs,
  tree,
  ...
}: {
  programs.rbw = {
    enable = true;
    settings = {
      inherit (tree.home.user.data) email;
      base_url = "https://bw.gensokyo.zone";
      identity_url = null;
      pinentry = pkgs.pinentry-gnome3;
      lock_timeout = 3600;
    };
  };
}
