{
  lib,
  config,
  channels,
  ...
}: let
  inherit (channels.nixfiles) packages legacyPackages;
in {
  tasks = {
    devShell.inputs = with packages.x86_64-linux; [
      deploy-rs
      terraform tflint
      alejandra deadnix statix
      ssh-to-age
    ];
  };
}
