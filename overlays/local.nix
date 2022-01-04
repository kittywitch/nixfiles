final: prev: {
  vips = prev.vips.override { libjxl = null; };

  kat-hugosite = final.callPackage ./kat-hugosite {};
}
