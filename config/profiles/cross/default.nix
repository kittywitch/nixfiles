rec {
  common = ./armvcommon.nix;
  armv7-base = ./armv7.nix;
  aarch64-base = ./aarch64.nix;


  aarch64 = {
    deploy.profile.cross = {
      enable = true;
      aarch64 = true;
    };
    imports = [
      aarch64-base
    ];
  };
  armv7l = {
    deploy.profile.cross = {
      enable = true;
      armv7l = true;
    };
    imports = [
      common
      armv7-base
    ];
  };
  armv6l = {
    deploy.profile.cross = {
      enable = true;
      armv6l = true;
    };
    imports = [
      common
    ];
  };
}
