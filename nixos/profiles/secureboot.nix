{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  environment.systemPackages = with pkgs; [
    sbctl
  ];
  boot = {
    loader = {
      systemd-boot.enable = mkForce false;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
