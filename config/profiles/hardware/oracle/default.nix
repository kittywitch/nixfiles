rec {
  common = ./common.nix;
  ubuntu-base = ./ubuntu.nix;
  oracle-base = ./oracle.nix;

  ubuntu = {
    deploy.profile.hardware.oracle = {
      common = true;
      ubuntu = true;
    };
    imports = [
      common
      ubuntu-base
    ];
  };
  oracle = {
    deploy.profile.hardware.oracle = {
      common = true;
      oracle = true;
    };
    imports = [
      common
      oracle-base
    ];
  };
}
