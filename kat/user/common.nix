{
  pkgs,
  tree,
  ...
}: {
  users.users.kat = {
    inherit (tree.kat.user.data) description;
    shell = pkgs.zsh;
  };
}
