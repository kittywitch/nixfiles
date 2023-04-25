{
  inputs,
  system,
  ...
}: {
  nixpkgs = {
    overlays = [
      inputs.spacebar.overlay.${system}
    ];
  };
}
