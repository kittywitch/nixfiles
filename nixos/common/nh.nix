{
  pkgs,
  inputs,
  ...
}: {
  programs.nh = {
    enable = true;
    package = inputs.nh.packages.${pkgs.system}.nh;
  };
}
