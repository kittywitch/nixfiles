let hardwareProfiles = { lib }:
let profiles = with profiles; lib.modList {
  modulesDir = ./.;
} // {
  ms-7b86 = {
    imports = [
      ms-7b86-base
      ryzen
      amdgpu
    ];
  };
  v330-14arr = {
    imports = [
      v330-14arr-base
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
}; in profiles;
in { __functor = self: hardwareProfiles; isModule = false; }
