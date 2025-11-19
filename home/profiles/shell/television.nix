{
  pkgs,
  inputs,
  ...
}: {
  programs.nix-search-tv = {
    enable = true;
    package = inputs.nix-search-tv.packages.${pkgs.system}.default;
    enableTelevisionIntegration = true;
  };
  programs.television = {
    enable = true;
  };
}
