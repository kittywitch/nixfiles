{ meta, tf, config, lib, pkgs, modulesPath, ... }:

{
  imports = with meta; [
    (modulesPath + "/installer/scan/not-detected.nix")
    hardware.local
    nixos.arc
    services.cockroachdb
    services.minio
    ./kanidm.nix
    ./vouch.nix
    ./home-assistant.nix
    ./zigbee2mqtt.nix
    ./mosquitto.nix
    ./postgres.nix
    ./nginx.nix
    ../../gui/nfs.nix
  ] ++ lib.optional (meta.trusted ? nixos.systems.tewi.default) meta.trusted.nixos.systems.tewi.default;

  services.cockroachdb.locality = "provider=local,network=gensokyo,host=${config.networking.hostName}";

  networks = {
    gensokyo = {
      interfaces = [
        "eno1"
      ];
      ipv4 = "100.88.107.41";
    };
  };

  networking = {
    useDHCP = false;
    interfaces = {
      eno1 = {
        useDHCP = true;
      };
    };
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    };
    kernelModules = [ "kvm-intel" ];
  };

  services.openiscsi = {
    enable = true;
    name = "";
    discoverPortal = "shanghai.tail.cutie.moe";
  };

  environment.etc."iscsi/initiatorname.iscsi" = lib.mkForce {
    source = config.secrets.files.openscsi-config.path;
  };

  secrets.variables.openscsi-password = {
    path = "gensokyo/tewi-scsi";
    field = "password";
  };

  secrets.files.openscsi-config = {
    text = "InitiatorName=${tf.variables.openscsi-password.ref}";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6c5d82b1-5d11-4c72-96c6-5f90e6ce57f5";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/85DC-72FA";
      fsType = "vfat";
    };
  };

  swapDevices = lib.singleton ({
    device = "/dev/disk/by-uuid/137605d3-5e3f-47c8-8070-6783ce651932";
  });

  system.stateVersion = "21.05";
}
