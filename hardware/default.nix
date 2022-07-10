{ lib, tree, ... }: let
  profiles = tree.prev;
  appendedProfiles = with profiles; {
    ms-7b86 = {
      imports = [
        ms-7b86
        ryzen
        amdgpu
      ];
    };
    rm-310 = {
      imports = [
        rm-310
        intel
      ];
    };
    v330-14arr = {
      imports = [
        v330-14arr
        ryzen
        amdgpu
        laptop
        networkmanager
      ];
    };
    x270 = {
      imports = [
        x270
        intel
        laptop
        networkmanager
        intel-gpu
      ];
    };
    eeepc-1015pem = {
      imports = [
        eeepc-1015pem
        intel
        laptop
      ];
    };
  };
in
profiles // appendedProfiles
