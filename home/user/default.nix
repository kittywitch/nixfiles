{tree, ...}:
tree.prev
// {
  nixos = {
    imports = with tree.prev; [
      nixos
      common
    ];
  };
  darwin = {
    imports = with tree.prev; [
      darwin
      common
    ];
  };
}
