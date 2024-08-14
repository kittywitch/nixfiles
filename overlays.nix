{
  inputs,
  tree,
  ...
}: [
  inputs.arcexprs.overlays.default
  inputs.darwin.overlays.default
  inputs.deploy-rs.overlay
  #inputs.hypridle.overlays.default
  #inputs.hyprlock.overlays.default
  (import tree.packages.default {inherit inputs tree;})
]
