{ config, lib, pkgs, std, ... }: let
  inherit (std) string;
  inherit (lib.modules) mkForce;
in
{
  console = {
    font = "Tamzen7x14";
    earlySetup = true;
  };
}
