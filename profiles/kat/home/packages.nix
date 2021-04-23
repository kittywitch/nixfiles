{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ hyperfine hexyl tokei ];
}
