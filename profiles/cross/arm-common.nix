{ config, ... }: {
  nix.settings = {
    substituters = [ "https://thefloweringash-armv7.cachix.org/" ];
    trusted-public-keys = [ "thefloweringash-armv7.cachix.org-1:v+5yzBD2odFKeXbmC+OPWVqx4WVoIVO6UXgnSAWFtso=" ];
  };
}
