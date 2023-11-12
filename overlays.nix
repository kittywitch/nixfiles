{
  inputs,
  tree,
  ...
}:
map (path: import "${path}/overlay.nix") [
  inputs.arcexprs
]
++ [
  inputs.darwin.overlays.default
  inputs.deploy-rs.overlay
  (import tree.packages.default {inherit inputs tree;})
]
