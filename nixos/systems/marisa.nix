{ config, lib, pkgs, modulesPath, tf, meta, ... }: with lib; {
  imports = with meta; [
    (modulesPath + "/profiles/qemu-guest.nix")
    hardware.manual
    services.nginx
    services.access
    services.irlsite
    services.cockroachdb
  ];

  services.cockroachdb.locality = "provider=buyvm,region=luxembourg,host=${config.networking.hostName}";

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/vda";
    };
    initrd = {
      availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk" ];
    };
    kernelModules = [ "kvm-amd" ];
  };

  networking = {
    hostName = "marisa";
    nameservers = [
      "1.1.1.1"
    ];
    useDHCP = false;
    defaultGateway = "104.244.72.1";
    defaultGateway6 = {
      address = "2605:6400:30::1";
      interface = "ens3";
    };
    interfaces.ens3 = {
      ipv4.addresses = [
        {
          address = config.networks.internet.ipv4;
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = config.networks.internet.ipv6;
          prefixLength = 48;
        }
      ];
    };
  };

  networks = {
    internet = {
      zone = "kittywit.ch.";
      ipv4 = "104.244.72.5";
      ipv6 = "2605:6400:30:eed1:6cf7:bbfc:b4e:15c0";
      interfaces = singleton "ens3";
      tcp = [ 1935 52969 ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6ed3e886-d390-433f-90ac-2b37aed9f15f";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/ba1425d4-8c18-47aa-b909-65bb710be400"; }
  ];

  system.stateVersion = "21.11";
}
