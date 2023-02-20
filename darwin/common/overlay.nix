{
  inputs,
  pkgs,
  tree,
  system,
  ...
}: {
  nixpkgs = {
    overlays = [
      inputs.spacebar.overlay.${system}
    ];
  };
}
