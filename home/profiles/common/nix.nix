_: {
  # TODO: add the same treatment as the other nix gc script
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    persistent = true;
  };
}
