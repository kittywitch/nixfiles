_: let
  hostConfig = { lib, ... }: let
      inherit (lib.modules) mkDefault;
    in {
    imports = [
    ];

    boot = {
      systemd-boot.enable = true;
      initrd = {
        availableKernelModules = ["virtio_pci" "xhci_pci" "usb_storage" "usbhid" "virtiofs"];
      };
      nix.settings = {
        extra-platforms = [ "x86_64-linux" ];
        extra-sandbox-paths = [ "/run/rosetta" "/run/binfmt" ];
      };
      binfmt.registrations."rosetta" = {
        interpreter = "/run/rosetta/rosetta";
        fixBinary = true;
        wrapInterpreterInShell = false;
        matchCredentials = true;
        magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
        mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/d91cbfb6-5a09-45d8-b226-fc97c6b09f61";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/FED9-4FD3";
        fsType = "vfat";
      };

      "/run/rosetta" = {
      device = "rosetta";
      fsType = "virtiofs";
      };
    };
    swapDevices = [
      {device = "/dev/disk/by-uuid/fd7d113e-7fed-44fc-8ad7-82080f27cd07";}
    ];

    networking.interfaces.enp0s1.useDHCP = mkDefault true;

    nixpkgs.hostPlatform = mkDefault "aarch64-linux";

    system.stateVersion = "22.11";
  };
in {
  arch = "aarch64-linux";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
