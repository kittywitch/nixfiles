_: let
  hostConfig = {
    lib,
    config,
    modulesPath,
    tree,
    ...
  }: {
    imports = with tree.nixos.roles; [
      server
      (modulesPath + "/profiles/qemu-guest.nix")
    ];
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/cf27e80b-f418-472e-8846-36073a76a628";
      fsType = "ext4";
    };
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    networking = {
      hostName = "ran";
      domain = "gensokyo.zone";
      nameservers = [
        "8.8.8.8"
      ];
      defaultGateway = "172.31.1.1";
      defaultGateway6 = {
        address = "fe80::1";
        interface = "eth0";
      };
      dhcpcd.enable = false;
      usePredictableInterfaceNames = lib.mkForce false;
      interfaces = {
        eth0 = {
          ipv4.addresses = [
            {
              address = "5.78.46.139";
              prefixLength = 32;
            }
          ];
          ipv6.addresses = [
            {
              address = "2a01:4ff:1f0:c700::1";
              prefixLength = 64;
            }
            {
              address = "fe80::9400:2ff:fe25:4acb";
              prefixLength = 64;
            }
          ];
          ipv4.routes = [
            {
              address = "172.31.1.1";
              prefixLength = 32;
            }
          ];
          ipv6.routes = [
            {
              address = "fe80::1";
              prefixLength = 128;
            }
          ];
        };
      };
    };
    boot = {
      loader.grub = {
        enable = true;
        device = "/dev/sda";
        version = 2;
      };
      initrd = {
        availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
        kernelModules = [];
      };
      kernelModules = [];
      extraModulePackages = [];
    };
    services.udev.extraRules = ''
      ATTR{address}=="96:00:02:25:4a:cb", NAME="eth0"
    '';
    system.stateVersion = "21.11";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
