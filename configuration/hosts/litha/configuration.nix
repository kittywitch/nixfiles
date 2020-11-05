# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common
      ../../desktop
      ../../xfce
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "litha";

  networking.useDHCP = false;
  networking.interfaces.enp34s0.useDHCP = true;
  networking.networkmanager.enable = true;

  system.stateVersion = "20.09";
  
}
