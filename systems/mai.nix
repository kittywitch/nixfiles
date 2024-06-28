_: let
  hostConfig = {
    lib,
    tree,
    modulesPath,
    ...
  }: let
    inherit (lib.modules) mkDefault;
  in {
    imports =
      [
        (modulesPath + "/profiles/qemu-guest.nix")
      ]
      ++ (with tree.nixos.profiles; [
        server
      ])
      ++ (with tree.nixos.hardware; [
        oracle_micro
      ])
      ++ (with tree.nixos.servers; [
      ]);

    system.stateVersion = "23.11";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
