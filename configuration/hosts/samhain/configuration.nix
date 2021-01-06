{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/common
    ../../profiles/desktop
    ../../profiles/xfce
    ../../profiles/gaming
    ../../profiles/development
    ../../profiles/network
    ../../profiles/yubikey
    ./services/nginx.nix
    ./services/thermal/thermal.nix
    ./services/torrenting.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" "xfs" ];

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  
  users.users.kat.extraGroups = [ "libvirtd" ];

  # video=efifb:off allows the 580 to be passed through regardless of being the boot display and allows the 560 to act as a console device
  # pci=noats means that it doesn't kernel panic on my specific configuration
  boot.kernelParams = [
    "amd_iommu=on"
    "pci=noats"
    "video=efifb:off"
  ]; # eventually switch to vfio-pci.ids to replace the boot.initrd.preDeviceCommands block
  boot.initrd.availableKernelModules =
    [ "amdgpu" "vfio-pci" ]; # vfio-pci is required for pci passthrough
  boot.kernelModules =
    [ "i2c-dev" "kvm-amd" ]; # i2c-dev is required for DDC/CI for screenstub

  # the script provided: https://alexbakker.me/post/nixos-pci-passthrough-qemu-vfio.html can be used to find iommu groups
  boot.initrd.preDeviceCommands = ''
    DEVS="0000:26:00.0 0000:26:00.1"
    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
  '';

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };

  environment.systemPackages = [
    pkgs.nur.repos.arc.packages.screenstub # for DDC/CI and input forwarding
    pkgs.nur.repos.arc.packages.scream-arc # for audio forwarding
    pkgs.ddcutil # for diagnostics on DDC/CI
    pkgs.virt-manager # obvious reasons
    pkgs.cachix # arc caching
  ];

  # arc caching
  nix = {
    binaryCaches = [ "https://arc.cachix.org" ];
    binaryCachePublicKeys =
      [ "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" ];
  };

  # audio for vm on startup
  systemd.user.services.scream-arc = {
    enable = true;
    description = "Scream Arc";
    serviceConfig = {
      ExecStart =
        "${pkgs.nur.repos.arc.packages.scream-arc}/bin/scream -i virbr0 -o pulse -v";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
    requires = [ "pulseaudio.service" ];
  };

  networking.hostName = "samhain";
  networking.hostId = "617050fc";

  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
    BusID "PCI:37:0:0"
  ''; # busId must be decimal conversion of the equivalent but matching the format, this was 0000:25:00.0

  services.xserver.wacom.enable = true;

  networking.useDHCP = false;
  networking.interfaces.enp34s0.useDHCP = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 445 139 9091 ]; # smb transmission
  networking.firewall.allowedUDPPorts = [ 137 138 4010 ]; # smb scream

  system.stateVersion = "20.09";

}

