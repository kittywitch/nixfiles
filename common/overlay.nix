{inputs, ...}: {
  nixpkgs = {
    overlays = map (path: import "${path}/overlay.nix") [
      inputs.arcexprs
    ];
  };
}
