{ lib, pkgs, ... }: let
  inherit (lib.modules) mkForce;
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
        oracle_flex
      ])
      ++ (with tree.nixos.servers; [
        weechat
        #matrix
        postgres
        web
      ]);

    system.stateVersion = "23.11";
  };
in {
  arch = "aarch64";
  deploy.hostname = "daiyousei.inskip.me";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
