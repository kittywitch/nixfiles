{
  inputs,
  tree,
  ...
}: [
  inputs.arcexprs.overlays.default
  inputs.darwin.overlays.default
  inputs.deploy-rs.overlay
  (import tree.packages.default {inherit inputs tree;})
]
