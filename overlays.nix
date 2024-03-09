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
  inputs.hypridle.overlays.default
  inputs.hyprlock.overlays.default
  (import tree.packages.default {inherit inputs tree;})
]
