{ config, pkgs, inputs, ... }: {
  services.nix-daemon.enable = true;
  nix = {
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nur.flake = inputs.nur;
      arc.flake = inputs.arcexprs;
      ci.flake = inputs.ci;
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-derivations = true
      keep-outputs = true
      extra-platforms = x86_64-darwin aarch64-darwin
      builders-use-substitutes = true
    '';
  };
}
