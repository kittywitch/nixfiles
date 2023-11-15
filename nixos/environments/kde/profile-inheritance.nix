{tree, ...}: {
  imports = with tree.nixos.profiles; [
    graphical
  ];

  home-manager.users.kat.imports = with tree.home.environments; [
    kde
  ];
}
