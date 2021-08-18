let hardwareProfiles = { lib }:
let profiles = with profiles; lib.domainMerge {
  folder = ""; # not used in this usage
  folderPaths = [
    ./.
    ../../trusted/profiles/hardware
  ];
} // {
  ms-7b86 = {
    imports = [
      ms-7b86-base
      ryzen
      amdgpu
    ];
  };
  rm-310 = {
    imports = [
      rm-310-base
      intel
    ];
  };
  v330-14arr = {
    imports = [
      v330-14arr-base
      ryzen
      amdgpu
      laptop
      wifi
    ];
  };
  eeepc-1015pem = {
    imports = [
        eeepc-1015pem-base
        intel
        laptop
      ];
    };
  }; in profiles;
in { __functor = self: hardwareProfiles; isModule = false; }
