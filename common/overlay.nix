{
  inputs,
  tree,
  ...
}: {
  nixpkgs = {
    overlays = import tree.overlays {inherit inputs;};
  };
}
