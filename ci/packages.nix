{channels, ...}: let
  inherit (channels.nixfiles) legacyPackages;
in {
  tasks = {
    devShell.inputs = with legacyPackages.x86_64-linux; [
      deploy-rs
      terraform
      lix
      tflint
      alejandra
      deadnix
      statix
      cachix
      ssh-to-age
    ];
  };
}
