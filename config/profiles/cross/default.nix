{ lib, tree, ... }: with lib; let
  profiles = tree.dirs // tree.files;
  appendedProfiles = with profiles; {
    aarch64 = {
      deploy.profile.cross = {
        enable = true;
        aarch64 = true;
      };
      imports = [
        aarch64
      ];
    };
    armv7l = {
      deploy.profile.cross = {
        enable = true;
        armv7l = true;
      };
      imports = [
        arm-common
        armv7
      ];
    };
    armv6l = {
      deploy.profile.cross = {
        enable = true;
        armv6l = true;
      };
      imports = [
        arm-common
        armv6
      ];
    };
  };
in
profiles // appendedProfiles
