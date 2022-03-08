{ inputs, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (import ./nur { inherit inputs; })
      (import inputs.emacs-overlay)
      (import ./dns { inherit inputs; })
      (import ./local)
    ] ++ (map (path: import "${path}/overlay.nix") [
      inputs.arcexprs
      inputs.katexprs
      inputs.anicca
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
