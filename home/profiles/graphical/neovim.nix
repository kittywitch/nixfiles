{tree, ...}: {
  imports = with tree.home.profiles; [
    nixvim.nixvim
  ];
}
