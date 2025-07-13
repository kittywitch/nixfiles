{
  inputs,
  tree,
  ...
}: [
  inputs.rbw-bitw.overlays.default
  #inputs.arcexprs.overlays.default
  inputs.darwin.overlays.default
  inputs.deploy-rs.overlays.default
  inputs.neorg-overlay.overlays.default
  inputs.niri.overlays.niri
  (import tree.packages.default {inherit inputs tree;})
  (_final: prev: {
    wivrn = prev.wivrn.override {cudaSupport = true;};
  })
]
