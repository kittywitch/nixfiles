{tree, ...}: {
  imports = with tree.home.profiles; [
    neovim
  ];
}
