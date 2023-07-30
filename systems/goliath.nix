_: let
  hostConfig = {
    config,
    lib,
    tree,
    pkgs,
    ...
  }: let
    inherit (lib.modules) mkDefault;
  in {
    imports = with tree.nixos.hardware;
      [
        common-wifi-bt
        sound
      ]
      ++ (with tree.nixos.roles; [
        gnome
        gaming
      ])
      ++ (with tree.kat; [
        gui
        gnome
      ]);

    environment.systemPackages = with pkgs; [
      fd # fd, better fine!
      ripgrep # rg, better grep!
      deadnix # dead-code scanner
      alejandra # code formatter
      statix # anti-pattern finder
      deploy-rs.deploy-rs # deployment system
      rnix-lsp # vscode nix extensions
      terraform # terraform
      kubectl
      k9s
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelParams = [
      "amdgpu.gpu_recovery=1"
    ];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];
    boot.supportedFilesystems = ["ntfs"];
    nixpkgs.hostPlatform = mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/cf7fc410-4e27-4797-8464-a409766928c1";
        fsType = "ext4";
      };
      "/boot/efi" = {
        device = "/dev/disk/by-uuid/D0D8-F8BF";
        fsType = "vfat";
      };
    };

    boot.initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };

    # Enable swap on luks
    boot.initrd.luks.devices."luks-111c4857-5d73-4e75-89c7-43be9b044ade".device = "/dev/disk/by-uuid/111c4857-5d73-4e75-89c7-43be9b044ade";
    boot.initrd.luks.devices."luks-111c4857-5d73-4e75-89c7-43be9b044ade".keyFile = "/crypto_keyfile.bin";
    boot.initrd.luks.devices."luks-af144e7f-e35b-49e7-be90-ef7001cc2abd".device = "/dev/disk/by-uuid/af144e7f-e35b-49e7-be90-ef7001cc2abd";

    services.openssh = {
      hostKeys = [
        {
          bits = 4096;
          path = "/var/lib/secrets/${config.networking.hostName}-osh-pk";
          type = "rsa";
        }
        {
          path = "/var/lib/secrets/${config.networking.hostName}-ed25519-osh-pk";
          type = "ed25519";
        }
      ];
      extraConfig = ''
        HostCertificate /var/lib/secrets/${config.networking.hostName}-osh-cert
        HostCertificate /var/lib/secrets/${config.networking.hostName}-osh-ed25519-cert
      '';
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/bebdb14c-4707-4e05-848f-5867764b7c27";}
    ];

    networking = {
      hostId = "dddbb888";
      useDHCP = false;
    };

    system.stateVersion = "21.11";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
