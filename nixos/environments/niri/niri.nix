{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
}
