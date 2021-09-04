{ lib, sources, tree, ... }: with lib; let
  profiles = tree.dirs // tree.files;
  appendedProfiles = with profiles; {
    ubuntu = { config, ... }: {
      deploy.profile.hardware.oracle = {
        ubuntu = true;
        common = true;
      };
      imports = with import (sources.tf-nix + "/modules"); [
        nixos.ubuntu-linux
        common
      ];
    };
    oracle = { config, ... }: {
      deploy.profile.hardware.oracle = {
        oracle = true;
        common = true;
      };
      imports = with import (sources.tf-nix + "/modules"); [
        nixos.oracle-linux
        common
      ];
    };
  };
in
profiles // appendedProfiles
