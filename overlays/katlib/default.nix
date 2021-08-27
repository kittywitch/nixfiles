self: super: {
  lib = super.lib.extend (self: super: import ./import.nix {
    inherit super;
    lib = self;
    isOverlayLib = true;
  });
}

