{ lib, tree, ... }: with lib; let
  profiles = (filterAttrs (n: v: v ? "default") tree.dirs)
    // tree.defaultDirs
    // (mapAttrs (n: v: removeAttrs v [ "default" ]) (filterAttrs (n: v: v ? "default") tree.dirs))
    // tree.files;
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
        wifi
      ];
    };
    x270 = {
      imports = [
        x270
        intel
        laptop
        wifi
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
