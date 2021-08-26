{ sources, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import sources.nixpkgs {
    overlays = [
      (import ./nur { inherit sources; })
      (import sources.emacs-overlay)
      (import ./rustfmt)
    /* # TODO: implement these
      (import ./vimrc)
    */
    ] ++ (map (path: import "${path}/overlay.nix") [
      sources.arcexprs
      sources.katexprs
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
