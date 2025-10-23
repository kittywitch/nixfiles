{
  inputs,
  tree,
  ...
}: {
  imports =
    (with tree.nixos.profiles; [
      uefi
    ])
    ++ (with tree.nixos.hardware; [
      amd
    ])
    ++ [
      inputs.nixos-hardware.outputs.nixosModules.framework-13-7040-amd
    ];
}
