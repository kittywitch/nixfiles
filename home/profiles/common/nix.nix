_: {
  # TODO: add the same treatment as the other nix gc script
  nix = {
    gc = {
      automatic = true;
      frequency = "weekly";
      persistent = true;
    };
  };
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
    store.cleanup = true;
    timestamp = "-7 days";
  };
}
