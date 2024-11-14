{
  inputs,
  tree,
  ...
}: {
  nixpkgs = {
    overlays = import tree.overlays {inherit inputs tree;};
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
  };
}
