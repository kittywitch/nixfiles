{
  inputs,
  tree,
  ...
}:
[
  (final: prev: inputs.arcexprs.overlays.default final prev)
  inputs.darwin.overlays.default
  inputs.deploy-rs.overlay
  #inputs.hypridle.overlays.default
  #inputs.hyprlock.overlays.default
  (import tree.packages.default {inherit inputs tree;})
]
