{ sources, system ? builtins.currentSystem, ... }@args:

let
  overlay = self: super: {
    nur = import sources.nur {
      nurpkgs = self;
      pkgs = self;
    };
    rustfmt = super.rustfmt.overrideAttrs ({ patches ? [ ], ... }: {
      patches = patches ++ [
        # Adds an option variant that merges all use statements into a single block.
        # Taken from https://github.com/rust-lang/rustfmt/pull/4680
        ./Implement-One-option-for-imports_granularity-4669.patch
      ];
    });
    linuxPackagesFor = kernel: (super.linuxPackagesFor kernel).extend (_: ksuper: {
      zfsUnstable = ksuper.zfsUnstable.overrideAttrs (old: { meta = old.meta // { broken = false; }; });
    });
  };
  pkgs = import sources.nixpkgs {
    overlays = [
      (import (sources.arcexprs + "/overlay.nix"))
      (import (sources.katexprs + "/overlay.nix"))
      (import sources.emacs-overlay)
      overlay
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ffmpeg-3.4.8"
      ];
    };
  };
in
pkgs
