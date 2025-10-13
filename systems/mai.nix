_: let
  hostConfig = {
    tree,
    modulesPath,
    ...
  }: {
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
        forgejo-runner
      ]);

    system.stateVersion = "23.11";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  colmena.tags = [
    "server"
    "oci"
  ];
  modules = [
    hostConfig
  ];
}
