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
    binaryCaches = [ "https://arc.cachix.org" "https://kittywitch.cachix.org" "https://nix-community.cachix.org" ];
    binaryCachePublicKeys =
        [ "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-derivations = true
      keep-outputs = true
      extra-platforms = x86_64-darwin aarch64-darwin
      builders-use-substitutes = true
    '';
  };
}
