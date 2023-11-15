{tree, ...}: {
  imports = with tree.nixos.profiles; [
    bootable
  ];
}
