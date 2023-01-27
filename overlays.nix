{inputs, ...}:
[
  inputs.deploy-rs.overlay
]
++ map (path: import "${path}/overlay.nix") [
  inputs.arcexprs
]
