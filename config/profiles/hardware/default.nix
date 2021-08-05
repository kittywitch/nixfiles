rec {
  ms-7b86-base = ./ms-7b86;
  v330-14arr-base = ./v330-14arr;
  rm-310-base = ./rm-310;
  hcloud-imperative = ./hcloud-imperative;
  ryzen = ./ryzen;
  intel = ./intel;
  amdgpu = ./amdgpu;

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
}
