_: let
  hostConfig = {tree, modulesPath, inputs, pkgs, ...}: {
    imports = with tree; [
      inputs.wsl.nixosModules.wsl
      "${modulesPath}/profiles/minimal.nix"
    ];

    fileSystems = {
      "/" = {
        device = "/dev/sdc";
        fsType = "ext4";
      };
      "/usr/lib/wsl/drivers" = {
        device = "drivers";
        fsType = "9p";
      };
      "/usr/lib/wsl/lib" = {
        device = "none";
        fsType = "overlay";
      };
      "/mnt/wsl" = {
        device = "none";
        fsType = "tmpfs";
      };
      "/mnt/wslg" = {
        device = "none";
        fsType = "tmpfs";
      };
      "/mnt/wslg/doc" = {
        device = "none";
        fsType = "overlay";
      };
      "/mnt/c" = {
        device = "drvfs";
        fsType = "9p";
      };
    };

    swapDevices = [
      { device = "/dev/sdb"; }
    ];

    wsl = {
      enable = true;
      defaultUser = "kat";
      startMenuLaunchers = true;
      wslConf.automount.root = "/mnt";
    };

    networking = {
      hostId = "dddbb888";
      useDHCP = false;
    };

    system.stateVersion = "22.05";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
