{
  inputs,
  tree,
  ...
}: {
  imports =
    (with tree.nixos.hardware; [
      amd_cpu
      amd_gpu
      uefi
    ])
    ++ [
      inputs.nixos-hardware.outputs.nixosModules.framework-13-7040-amd
    ];
}
