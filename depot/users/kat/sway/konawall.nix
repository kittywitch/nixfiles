{ config, pkgs, ... }:

{
  services.konawall = {
    enable = true;
    package = pkgs.konawall-sway;
  };
}
