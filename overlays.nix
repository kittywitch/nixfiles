{
  inputs,
  tree,
  ...
}:
map (path: import "${path}/overlay.nix") [
  inputs.arcexprs
]
++ [
  inputs.deploy-rs.overlay
  inputs.konawall-rs.overlays.default
  (import tree.packages.default {inherit inputs tree;})
]
