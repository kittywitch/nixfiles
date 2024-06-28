_: {
  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "deploy"
      ];
    };
  };
}
