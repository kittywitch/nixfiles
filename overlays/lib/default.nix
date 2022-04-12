self: super: {
  lib = super.lib.extend (self: super: import ./overlay.nix {
    inherit super;
    lib = self;
    isOverlayLib = true;
  });
}
