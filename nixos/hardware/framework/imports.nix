{
  inputs,
  tree,
  ...
}: {
  imports =
    (with tree.nixos.profiles; [
        uefi
    ])
    ++ [
      inputs.nixos-hardware.outputs.nixosModules.framework-13-7040-amd
    ];
}
