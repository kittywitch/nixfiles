{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    #./wireguard.nix
  ];

  #meta.deploy.profiles = [];
  meta.deploy.ssh.host = "boline.kittywit.ch";
  
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.hostId = "0417b551";
  networking.hostName = "boline";

  networking.useDHCP = false;
  networking.interfaces.ens3.ipv4.addresses = [ {
      address = "104.244.73.10";
      prefixLength = 24;
  }];
  networking.defaultGateway = "104.244.73.1";
  networking.nameservers = [ "1.1.1.1" ];

  system.stateVersion = "20.09";
}

