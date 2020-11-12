# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../profiles/common
    ../../profiles/desktop
    ../../profiles/xfce
    ../../profiles/network
    ../../profiles/yubikey
  ];


  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "mabon"; # Define your hostname.
  
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wls3.useDHCP = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "20.09"; # Did you read the comment?

}


