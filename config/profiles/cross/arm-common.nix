{ config, ... }: {
  nix = {
    binaryCaches = [ "https://thefloweringash-armv7.cachix.org/" ];
    binaryCachePublicKeys = [ "thefloweringash-armv7.cachix.org-1:v+5yzBD2odFKeXbmC+OPWVqx4WVoIVO6UXgnSAWFtso=" ];
  };
}
