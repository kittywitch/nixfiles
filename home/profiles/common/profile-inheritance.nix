{tree, ...}: {
  imports = with tree.home.profiles; [
    shell
    neovim
  ];
}
