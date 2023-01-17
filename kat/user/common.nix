{pkgs,tree,...}: {
  users.users.kat = {
    inherit (import tree.kat.user.data) description;
    shell = pkgs.zsh;
  };
}
