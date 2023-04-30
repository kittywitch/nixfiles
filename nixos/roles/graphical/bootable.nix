{tree, ...}: {
  imports = with tree.nixos.roles; [
    bootable
  ];
}
