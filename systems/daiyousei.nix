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
        oracle_flex
      ])
      ++ (with tree.nixos.servers; [
      ]);

    system.stateVersion = "23.11";
  };
in {
  arch = "aarch64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
