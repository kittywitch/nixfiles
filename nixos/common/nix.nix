{ pkgs, ...}: {
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
    package = pkgs.lix;
  };
  system = {
    rebuild.enableNg = true;
  };
}
