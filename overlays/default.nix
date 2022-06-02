{ inputs, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (import ./nur { inherit inputs; })
      (import ./dns { inherit inputs; })
      (import ./local)
      (import ./lib)
    ] ++ (map (path: import "${path}/overlay.nix") [
      inputs.arcexprs
    ]);
    config = {
      allowUnfree = true;
      allowBroken = true;
      permittedInsecurePackages = [
        "ffmpeg-3.4.8"
        "ffmpeg-2.8.17"
      ];
    };
  };
in
pkgs
