_: let
  hostConfig = {
    tree,
    pkgs,
    lib,
    inputs,
    ...
  }: {
    imports =
      (with tree.nixos.hardware; [
        framework
      ])
      ++ (with tree.nixos.profiles; [
        graphical
        gaming
        wireless
        laptop
        bcachefs
        sdr
        secureboot
      ])
      ++ (with tree.nixos.environments; [
        xfce
      ]);
    config = {
      home-manager.users.kat.imports =
        (with tree.home.profiles; [
          graphical
          devops
        ])
        ++ (with tree.home.environments; [
          xfce
        ]);

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/861e8815-9327-4e49-915b-73a3b0bdfa25";
          fsType = "bcachefs";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/DD84-303D";
          fsType = "vfat";
        };
      };

        boot.extraModprobeConfig = "options snd_hda_intel power_save=0";

      services.printing.enable = true;

      swapDevices = [
        {device = "/dev/disk/by-uuid/04bd322e-dca0-43b8-b588-cc0ef1b1488e";}
      ];

      boot = {
        supportedFilesystems = ["ntfs"];
      };

      networking = {
        useDHCP = false;
      };

      system.stateVersion = "24.05";
    };
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
