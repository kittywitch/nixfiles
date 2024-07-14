{
  lib,
  config,
  channels,
  ...
}: let
  inherit (channels.nixfiles) legacyPackages;
in {
  tasks = {
    devShell.inputs = with legacyPackages.x86_64-linux; [
      deploy-rs
      terraform tflint
      alejandra deadnix statix
      ssh-to-age
    ];
  };
}
