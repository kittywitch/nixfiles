{ inputs, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import inputs.nixpkgs-darwin {
    inherit system;
    overlays = [
      (import ./nur { inherit inputs; })
      (import inputs.emacs-overlay)
      (import ./dns { inherit inputs; })
      (import ./local)
      (import ./lib)
    ] ++ (map (path: import "${path}/overlay.nix") [
      inputs.arcexprs
      inputs.anicca
    ]);
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowUnsupportedSystem = true;
      permittedInsecurePackages = [
        "ffmpeg-3.4.8"
        "ffmpeg-2.8.17"
      ];
    };
  };
in
pkgs
