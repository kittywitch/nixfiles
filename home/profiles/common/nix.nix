_: {
  # TODO: add the same treatment as the other nix gc script
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    persistent = true;
  };
  # adds to nixpkgs.overlay, made irrelevant due to `home-manager.useGlobalPkgs`
  chaotic.nyx.overlay.enable = false;
}
