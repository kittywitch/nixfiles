{ lib, sources, tree, ... }: with lib; let
  profiles = tree.prev;
  appendedProfiles = with profiles; {
    ubuntu = { config, ... }: {
      deploy.profile.hardware.oracle = {
        ubuntu = true;
        common = true;
      };
      kw.oci.base = "Canonical Ubuntu";
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
      kw.oci.base = "Oracle Linux";
      imports = with import (sources.tf-nix + "/modules"); [
        nixos.oracle-linux
        common
      ];
    };
  };
in
profiles // appendedProfiles
