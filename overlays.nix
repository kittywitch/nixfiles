{
  inputs,
  tree,
  ...
}: [
  # https://lix.systems/add-to-config/#flake-based-configurations
  (_final: prev: {
    inherit
      (prev.lixPackageSets.stable)
      nixpkgs-review
      nix-eval-jobs
      nix-fast-build
      colmena
      ;
  })
  inputs.colmena.overlays.default
  inputs.ida-pro-overlay.overlays.default
  # To get this not to garbage collect, make sure to create a gcroot by manually
  # building the package with an output (anywhere you want, really). You can't
  # then delete that output, however, or rename or move it. So place it somewhere
  # you're ok with it being.
  (final: prev: {
    ida-pro-kat = prev.callPackage final.ida-pro {
      runfile = final.requireFile {
        name = "ida-pro_92_x64linux.run";
        message = "Don't copy that floppy~!";
        hash = "sha256-qt0PiulyuE+U8ql0g0q/FhnzvZM7O02CdfnFAAjQWuE=";
      };
      normalScript = final.requireFile {
        name = "ida-normalScript.py";
        message = "Floppy; copied.";
        hash = "sha256-8UWf1RKsRNWJ8CC6ceDeIOv4eY3ybxZ9tv5MCHx80NY=";
      };
    };
  })
  inputs.rbw-bitw.overlays.default
  #inputs.arcexprs.overlays.default
  inputs.nix-gaming.overlays.default
  inputs.darwin.overlays.default
  inputs.deploy-rs.overlays.default
  inputs.neorg-overlay.overlays.default
  inputs.niri.overlays.niri
  inputs.proton-cachyos.overlays.default
  (import tree.packages.default {inherit inputs tree;})
  (_final: prev: {
    wivrn = prev.wivrn.overrideAttrs (old: {
      cudaSupport = true;
    });
  })
]
