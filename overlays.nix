{inputs, tree, ...}: [
  inputs.deploy-rs.overlay
  (import tree.packages.default { inherit inputs tree; })
] ++ map (path: import "${path}/overlay.nix") [
  inputs.arcexprs
]
