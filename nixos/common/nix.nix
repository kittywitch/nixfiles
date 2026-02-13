_: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
    settings = {
      extra-experimental-features = [ "pipe-operator" ];
      auto-optimise-store = true;
      trusted-users = [
        "deploy"
      ];
    };
    #package = pkgs.lixPackageSets.stable.lix;
  };
}
