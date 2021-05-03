{ config, pkgs, lib, ... }:

{
  services.konawall = { enable = true; interval = "20m"; };
}
