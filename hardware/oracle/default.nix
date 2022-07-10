{ inputs, tree, ... }: let
  profiles = tree.prev;
  appendedProfiles = with profiles; {
    ubuntu = { config, ... }: {
      kw.oci.base = "Canonical Ubuntu";
      imports = with import (inputs.tf-nix + "/modules"); [
        nixos.ubuntu-linux
        common
      ];
    };
    oracle = { config, ... }: {
      kw.oci.base = "Oracle Linux";
      imports = with import (inputs.tf-nix + "/modules"); [
        nixos.oracle-linux
        common
      ];
    };
  };
in
profiles // appendedProfiles
