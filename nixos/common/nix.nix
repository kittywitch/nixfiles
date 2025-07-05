{inputs, pkgs, ...}: {
  programs.nh = {
    enable = true;
    package = inputs.nh.packages.${pkgs.system}.nh;
  };
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
