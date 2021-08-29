{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ hyperfine hexyl tokei nixpkgs-fmt pandoc ];
}
