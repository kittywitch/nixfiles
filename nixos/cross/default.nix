{ lib, tree, ... }: with lib; let
  profiles = tree.prev;
  appendedProfiles = with profiles; {
    aarch64 = {
      imports = [
        aarch64
      ];
    };
    armv7l = {
      imports = [
        arm-common
        armv7
      ];
    };
    armv6l = {
      imports = [
        arm-common
        armv6
      ];
    };
  };
in
profiles // appendedProfiles
