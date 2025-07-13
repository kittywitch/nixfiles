_: {
  services.nixos-cli = {
    enable = true;
    config = {
      use_nvd = true;
      apply = {
        use_nom = true;
      };
    };
  };
}
