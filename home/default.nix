{tree, ...}:
tree.prev
// {
  base = {
    imports = with tree.prev; [
      base16
      shell
      neovim
    ];
  };
  work = {
    imports = with tree.prev; [
      work
      wezterm
    ];
  };
}
