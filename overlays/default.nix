{ sources, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import sources.nixpkgs {
    overlays = [
      (import ./nur { inherit sources; })
      (import sources.emacs-overlay)
      (import ./rustfmt)
      (import ./ff-tst-style)
      (import ./ff-uc-style)
    /* # TODO: implement these
      (import ./waybar-style)
      (import ./wofi-style)
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
