{
  pkgs,
  tree,
  ...
}: {
  users.users.kat = {
    inherit (tree.home.user.data) description;
    shell = pkgs.zsh;
  };
}
