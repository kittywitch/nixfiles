{ sources, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import sources.nixpkgs {
    overlays = [
      (import ./nur { inherit sources; })
      (import sources.emacs-overlay)
      (import ./rustfmt)
      (import ./katlib)
      (import ./katpkgs)
      (import ./dns { inherit sources; })
    ] ++ (map (path: import "${path}/overlay.nix") [
      sources.arcexprs
      sources.anicca
    ]);
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ffmpeg-3.4.8"
      ];
    };
  };
in
pkgs
