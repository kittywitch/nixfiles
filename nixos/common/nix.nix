_: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "deploy"
      ];
    };
  };
}
